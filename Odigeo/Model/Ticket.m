//
//  Ticket.m
//  Odigeo
//
//  Created by Fernando Canon on 29/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "Ticket.h"
#import "InBoundFlight.h"
#import "OutBoundFlight.h"


@implementation Ticket

@dynamic amount;
@dynamic currency;
@dynamic euroPrice;
@dynamic inBoundFlight;
@dynamic outBountFlight;

-(void) loadPriceFromDictionary:(NSDictionary*) dictionary{
    
    NSNumber *tmpValue = dictionary[@"amount"];
    NSDecimalNumber *amount =[NSDecimalNumber decimalNumberWithDecimal:[tmpValue decimalValue]];
    self.amount =amount;
    self.currency =dictionary[@"currency"];
}


@end
