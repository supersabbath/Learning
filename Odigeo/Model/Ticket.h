//
//  Ticket.h
//  Odigeo
//
//  Created by Fernando Canon on 29/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+TBAdditions.h"
@class InBoundFlight, OutBoundFlight;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSDecimalNumber * euroPrice;
@property (nonatomic, retain) InBoundFlight *inBoundFlight;
@property (nonatomic, retain) OutBoundFlight *outBountFlight;

-(void) loadPriceFromDictionary:(NSDictionary*) dictionary;
@end
