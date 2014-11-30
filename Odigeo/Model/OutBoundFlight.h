//
//  OutBoundFlight.h
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+TBAdditions.h"


@class Ticket;

@interface OutBoundFlight : NSManagedObject

@property (nonatomic, retain) NSString * airline;
@property (nonatomic, retain) NSDate * arrivalDate;
@property (nonatomic, retain) NSDate * departureDate;
@property (nonatomic, retain) NSString * destiny;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) Ticket *ticket;

-(void) loadFlightDataFromDictionary:(NSDictionary*) dictionary;

@end
