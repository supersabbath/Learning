//
//  InBoundFlight.m
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "InBoundFlight.h"
#import "Ticket.h"


@implementation InBoundFlight

@dynamic airline;
@dynamic arrivalDate;
@dynamic departureDate;
@dynamic origin;
@dynamic destiny;
@dynamic ticket;

-(void) loadFlightDataFromDictionary:(NSDictionary*) dictionary{
    
    self.airline = dictionary[@"airline"];
    
    NSDate *arrival = [self createDateFromString:[ self concatDate:dictionary[@"arrivalDate"] withTime:dictionary[@"arrivalTime"]]];

    self.arrivalDate = arrival;
    NSDate *departure =  [self createDateFromString:[ self concatDate:dictionary[@"departureDate"] withTime:dictionary[@"departureTime"]]];
 
    self.departureDate=departure;
    self.destiny =dictionary[@"destiny"];
    
    self.origin = dictionary[@"origin"];
}

-(NSString*) concatDate:(NSString*) dateString withTime:(NSString*)timeString {
    
    NSString *newString =[dateString stringByAppendingFormat:@" %@",timeString];
     
    return newString;
}

-(NSDate*) createDateFromString:(NSString *) dateString {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormat setTimeZone:gmt];
    
    NSDate *newDate= [dateFormat dateFromString:dateString];
    return newDate;
}



@end
