//
//  FCPCoreDataImporter.m
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "FCPCoreDataImporter.h"
#import "WSManager.h"
#import "WSCurrencyConverter.h"

#import "Ticket.h"
#import "InBoundFlight.h"
#import "OutBoundFlight.h"


@interface FCPCoreDataImporter ()

@property (strong, nonatomic) NSManagedObjectContext *storageContext;
@property (strong, nonatomic) WSManager *webservice;
@property (strong,nonatomic) WSCurrencyConverter *currencyService;

@property (nonatomic) int batchCount;
@end

@implementation FCPCoreDataImporter


- (id)initWithContext:(NSManagedObjectContext *)context webservice:(WSManager *)webservice andWSCurrency:(WSCurrencyConverter*)  wsConverter
{
    self = [super init];
    if (self) {
        _storageContext = context;
        _webservice = webservice;
        _currencyService = wsConverter;
    }
    return self;
}

- (void) import
{
    _batchCount = 0;
    NSURL *serviceURL = [NSURL URLWithString:OdigeServiceURL];
    
    [_webservice fetchFlightsforURL:serviceURL withCompletionBlock :^(NSArray *ticketsInfo, NSError *error) {

        NSLog(@"WSService  returns %d fresh new objects", ticketsInfo.count);
        [_storageContext performBlock:^{
            
            
            for (NSDictionary *ticket in ticketsInfo) {  // no me tengo que precupar por eficiencia porque no hay un id para identifar cada vuelo. Solo se insertan
                Ticket *fligthTicket =[Ticket createManagedObjectInContext:_storageContext];
                [fligthTicket loadPriceFromDictionary:ticket[@"price"]];
                
                [self performSyncCurrencyConversionRateFetchForTicket:fligthTicket]; // this will block this thread
               
                InBoundFlight *inBound=[InBoundFlight createManagedObjectInContext:_storageContext];
                [inBound loadFlightDataFromDictionary:ticket[@"inBound"]];
                
                OutBoundFlight *outBound=[OutBoundFlight createManagedObjectInContext:_storageContext];
                [outBound loadFlightDataFromDictionary:ticket[@"outBound"]];
                
                fligthTicket.inBoundFlight = inBound;
                fligthTicket.outBountFlight = outBound;
                
                self.batchCount++;
                
                if (self.batchCount  == ticketsInfo.count) {  // notificamos al main context para que refrescar cada 10
                    NSError *error = nil;
                    [_storageContext save:&error];
                    NSLog(@"_____________Saving __________")
                    if (error) {
                        NSLog(@"Error: %@", error.userInfo);
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"FTCCoreDataImportFinish" object:self];
                    });
                   
                }
                
            }
        }];
    }];
    
}

-(void ) performSyncCurrencyConversionRateFetchForTicket:(Ticket*) ticket
{
    
        if (![ticket isEuroPriceAvailable]) {
    
            [_currencyService fetchCurrencyConvertionRate:ticket.currency withCompletionBlock:^(NSDictionary *rates, NSError *error) {
    
                if (!error && rates) {
    
                    NSDecimalNumber *newValue = [ticket.amount decimalNumberByMultiplyingBy:[[rates allValues] firstObject]];
                    ticket.euroPrice = newValue;
 
                }
                else{
                    NSLog(@"Error: %@",[[error userInfo] debugDescription]);
                     ticket.euroPrice = ticket.amount; 
                }
            }];
    
        }else{
             NSLog(@"Not downloading euro %@",[ticket.amount stringValue]);
          
            ticket.euroPrice = ticket.amount; // NOTE: set the transient property, it will no be store
        }
}


@end
