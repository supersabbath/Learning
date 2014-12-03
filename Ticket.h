//
//  Ticket.h
//  Odigeo
//
//  Created by Fernando Canon on 03/12/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSDecimalNumber * euroPrice;
@property (nonatomic, retain) NSSet *flights;
@end

@interface Ticket (CoreDataGeneratedAccessors)

- (void)addFlightsObject:(Flight *)value;
- (void)removeFlightsObject:(Flight *)value;
- (void)addFlights:(NSSet *)values;
- (void)removeFlights:(NSSet *)values;

@end
