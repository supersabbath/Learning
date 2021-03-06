//
//  Ticket.m
//  Odigeo
//
//  Created by Fernando Canon on 03/12/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "Ticket.h"
#import "Flight.h"


@implementation Ticket

@dynamic amount;
@dynamic currency;
@dynamic euroPrice;
@dynamic flights;
 

-(void) loadPriceFromDictionary:(NSDictionary*) dictionary{
    
    NSNumber *tmpValue = dictionary[@"amount"];
    NSDecimalNumber *amount =[NSDecimalNumber decimalNumberWithDecimal:[tmpValue decimalValue]];
    self.amount =amount;
    self.currency =dictionary[@"currency"];
}

#pragma mark -Currency Process

-(BOOL) isEuroPriceAvailable
{
    
    return [self.currency isEqualToString:@"EUR"];
    
}



@end
