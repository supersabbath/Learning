//
//  FCPCoreDataImporter.m
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "FCPCoreDataImporter.h"
#import "WSManager.h"

#import "Ticket.h"
#import "InBoundFlight.h"
#import "OutBoundFlight.h"


@interface FCPCoreDataImporter ()

@property (nonatomic, strong) NSManagedObjectContext *storageContext;
@property (nonatomic, strong) WSManager *webservice;
@property (nonatomic) int batchCount;
@end

@implementation FCPCoreDataImporter


- (id)initWithContext:(NSManagedObjectContext *)context webservice:(WSManager *)webservice
{
    self = [super init];
    if (self) {
        _storageContext = context;
        _webservice = webservice;
    }
    return self;
}

- (void) import
{
    _batchCount = 0;
    NSURL *serviceURL = [NSURL URLWithString:OdigeServiceURL];
    
    [_webservice fetchFlightsforURL:serviceURL withCompletionBlock :^(NSArray *ticketsInfo, NSError *error) {
        
        [_storageContext performBlock:^{
            
            for (NSDictionary *ticket in ticketsInfo) {  // no me tengo que precupar por eficiencia por que no hay un id para identifar cada vuelo
                Ticket *fligthTicket =[Ticket createManagedObjectInContext:_storageContext];
                [fligthTicket loadPriceFromDictionary:ticket[@"price"]];
//                InBoundFlight *inBound=[InBoundFlight createManagedObjectInContext:_storageContext];
//               [inBound loadFlightDataFromDictionary:ticket[@"inBound"]];
//               OutBoundFlight *outBound=[OutBoundFlight createManagedObjectInContext:_storageContext];
//                [outBound loadFlightDataFromDictionary:ticket[@"outBound"]];
//                
//                fligthTicket.inBoundFlight = inBound;
//                fligthTicket.outBountFlight = outBound;
//                
                 self.batchCount++;
                
                if (self.batchCount % 100 == 0) {  // notificamos al main context para que refrescar cada 10
                    NSError *error = nil;
                    [_storageContext save:&error];
                    if (error) {
                        NSLog(@"Error: %@", error.userInfo);
                    }
                    
                }
                
            }
        }];
    }];

}
@end
