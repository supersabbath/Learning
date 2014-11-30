//
//  WSCurrencyConverter.m
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "WSCurrencyConverter.h"

@interface WSCurrencyConverter () <NSURLConnectionDelegate>


@property (strong ,nonatomic) NSMutableData *inComingData;
@property (strong, nonatomic) NSMutableDictionary *cache;
@property (strong, nonatomic) NSMutableDictionary *blocksQueueDictionary;
@property (retain, nonatomic) dispatch_queue_t queue;
@property (copy, nonatomic) WSCurrencyCompletion opertionBlock;
@end


@implementation WSCurrencyConverter



- (instancetype)initWithServiceURL:(NSString*)urlString
{
    self = [super init];
    if (self) {
        _serviceURL = urlString;
        _cache =[@{} mutableCopy];
        _queue = dispatch_queue_create("com.fcp.MyQueue", DISPATCH_QUEUE_SERIAL);

    }
    return self;
}
#pragma mark - WSCurrencyConverter lifeCycle

//NOTE:: this service will cache all the request..
- (void)fetchCurrencyConvertionRate:(NSString*)currency  withCompletionBlock:(WSCurrencyCompletion) block
{
    _opertionBlock = block;
    
    dispatch_async(_queue, ^{
        
        id rate  = [self ratefromCache:currency];
        
        if (rate == [NSNull null]) {
            
            NSURL *requestURL = [self urlForCurrency:currency];
            NSURLResponse *response= nil;
            NSError *error =nil;
            NSURLRequest *rqest = [self currencyServiceRequestForURL:requestURL];
            NSData *responseData = [NSURLConnection sendSynchronousRequest:rqest returningResponse:&response error:&error];
            
            if (responseData == nil) {
              
                NSError *er =[NSError errorWithDomain:@"FCPError" code:1 userInfo:[error userInfo]];
                
                [self finishWithBlock:_opertionBlock andResonseData:nil andError:er];
            
            }else {
                
        
                NSDictionary *formattedResponse = [self createResponseAndSaveToCache:responseData];
                
                
                [self finishWithBlock:_opertionBlock andResonseData:formattedResponse andError:nil];
            }
        }else { // in cache
            
            NSLog(@"*******************  from Cache");
            [self finishWithBlock:_opertionBlock andResonseData:@{currency:rate,@"cache":@"true"} andError:nil];
            
        }
    });
}

-(void) finishWithBlock:(WSCurrencyCompletion)block andResonseData:(NSDictionary*) respose andError:(NSError*) error{

    dispatch_async(dispatch_get_main_queue(), ^{
        block (respose,error);
    });
}

-(NSURL*) urlForCurrency:(NSString*) currency {

    NSString *completeURL  = [_serviceURL stringByAppendingFormat:@"?from=%@&to=EUR",currency];
    return [NSURL URLWithString:completeURL];
}

-(NSMutableURLRequest*) currencyServiceRequestForURL:(NSURL*) serviceURL
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [request setHTTPShouldUsePipelining:YES]; // faster htpp communication if server supports it
    return request;
    
}

#pragma mark -  Cache

-(id) ratefromCache:(NSString*) currency
{
    NSNumber *rate = [_cache objectForKey:currency];
    
    if (!rate) {
        return  [NSNull null];
    }
    
    return rate;
}


-(void) safeToCacheRate:(NSNumber*)number forKey:(NSString*) currency
{
    _cache[currency]=number;
}

-(NSDictionary *) createResponseAndSaveToCache:(id) jsonData
{
    
    
    id result = [self parseDataToJson:jsonData];
    
    if (result == nil){
       //TODO: control parisng errors
        return nil;
    }
    
    NSDictionary *responseContainer =nil;
    NSDictionary *currencyValue=jsonData;
    
    if (currencyValue[@"err"]) {
        
        NSError *errr =[NSError errorWithDomain:@"FCPError" code:1 userInfo: @{@"error":jsonData[@"err"]}];
        [self finishWithBlock:_opertionBlock andResonseData:nil andError:errr];
        
    }else{
        
        NSString *currencyKey =currencyValue[@"from"];
        
        NSDecimalNumber *rate =[NSDecimalNumber decimalNumberWithDecimal:[(NSNumber*)currencyValue[@"rate"] decimalValue ]];
        
        _cache[currencyKey]=rate;
        
         responseContainer = @{currencyKey:rate};
        
        return responseContainer;
    }
    
    return responseContainer;
}



-(void) addBlockToQueue:(WSCurrencyCompletion) block forKey:(NSString*)key{

    NSMutableArray *group = _blocksQueueDictionary[key]; // all blocks are waiting for the same queue
    
    if (group == nil) {
        group = [@[] mutableCopy];
    }
    
    [group addObject:block];
    
    [_blocksQueueDictionary setObject:block forKey:key];
}



#pragma mark -Data Parsing 


-(id) parseDataToJson:(NSData*)data{
   
    NSError *jsonError = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    return result;

}


//#pragma mark - NSURLConnection delegates
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    
//    _inComingData = [NSMutableData data];
//    
//}
//
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [_inComingData appendData:data];
//    
//}
//
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    
//    
//    NSDictionary * currencyValue = (NSDictionary *)[self parseDataToJson:_inComingData];
//    if (currencyValue[@"err"]) {
//        //_block(nil,currencyValue[@"err"]);
//    }else{
//        
//        _cache[currencyValue[@"to"]]=currencyValue[@"rate"];
//    }
//}
//
//
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    
//}
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
//    
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[cachedResponse response];
//    
//    // Look up the cache policy used in our request
//    if([connection currentRequest].cachePolicy == NSURLRequestUseProtocolCachePolicy) {
//        NSDictionary *headers = [httpResponse allHeaderFields];
//        NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
//        NSString *expires = [headers valueForKey:@"Expires"];
//        if((cacheControl == nil) && (expires == nil)) {
//            NSLog(@"server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
//            return nil; // don't cache this
//        }
//    }
//    return cachedResponse;
//}


@end
