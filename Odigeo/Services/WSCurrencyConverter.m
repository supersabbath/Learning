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

@property (readwrite,nonatomic) BOOL isServiceOverloaded;
@end


@implementation WSCurrencyConverter



- (instancetype)initWithServiceURL:(NSString*)urlString
{
    self = [super init];
    if (self) {
        _serviceURL = urlString;
        _cache =[@{} mutableCopy];
        _queue = dispatch_queue_create("com.fcp.MyQueue", DISPATCH_QUEUE_SERIAL);
        _isServiceOverloaded = NO;
    }
    return self;
}
#pragma mark - WSCurrencyConverter lifeCycle

//NOTE:: this service will cache all the request..
- (void)fetchCurrencyConvertionRate:(NSString*)currency  withCompletionBlock:(WSCurrencyCompletion) block
{
    _opertionBlock = block;
    
    if (_isServiceOverloaded) {
        NSError *error =[NSError errorWithDomain:@"FCPError" code:1 userInfo:@{@"error":@"se han excedido el numero de peticiones"}];
        
        [self finishWithBlock:_opertionBlock andResonseData:nil andError:error];
    }
    
    dispatch_sync(_queue, ^{

        id rate  = [self ratefromCache:currency];
        
        if (rate == [NSNull null]) {
          
            NSURL *requestURL = [self urlForCurrency:currency];
            NSURLResponse *response= nil;
            NSError *error =nil;
            NSURLRequest *rqest = [self currencyServiceRequestForURL:requestURL];
            NSData *responseData = [NSURLConnection sendSynchronousRequest:rqest returningResponse:&response error:&error];
            
            
            if (responseData == nil ) {
              
                NSError *er =[NSError errorWithDomain:@"FCPError" code:1 userInfo:[error userInfo]];
                
                [self finishWithBlock:_opertionBlock andResonseData:nil andError:er];
            
            } else if (responseData.length == 970){  // NOTE: exceso de peticiones.. erro
            
                _isServiceOverloaded = YES;
            
            } else {
                
                NSDictionary *formattedResponse = [self formatResponse:responseData];
                
                [self safeToCacheRate:[[formattedResponse allValues] firstObject] forKey:currency];
                
                [self finishWithBlock:_opertionBlock andResonseData:formattedResponse andError:nil];
            }
        }else { // in cache
            
          //  NSLog(@"*******************  from Cache");
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [request setHTTPShouldUsePipelining:YES]; // faster htpp communication if server supports it
    return request;
    
}

#pragma mark -  Cache

-(id) ratefromCache:(NSString*) currency
{
    NSNumber *rate = [_cache objectForKey:currency];
    
  //  NSLog(@"rate in chace %@",currency );
    if (!rate) {
        return  [NSNull null];
    }
    
    return rate;
}


-(void) safeToCacheRate:(NSNumber*)number forKey:(NSString*) currency
{
   // NSLog(@"Savin to cache");
    _cache[currency]=number;
}

-(NSDictionary *) formatResponse:(id) jsonData
{
    
    
    NSDictionary *result = ( NSDictionary *)[self parseDataToJson:jsonData];
    
    if (result == nil){
       //TODO: control parisng errors
        return nil;
    }
    
    NSDictionary *responseContainer =nil;
 
    
    if ([result objectForKey:@"err"]) {
        
        NSError *errr =[NSError errorWithDomain:@"FCPError" code:1 userInfo: @{@"error":result[@"err"]}];
        [self finishWithBlock:_opertionBlock andResonseData:nil andError:errr];
        
    }else{
        
        NSString *currencyKey =result[@"from"];
        
        NSDecimalNumber *rate =[NSDecimalNumber decimalNumberWithDecimal:[(NSNumber*)result[@"rate"] decimalValue ]];

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



@end
