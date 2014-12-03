//
//  OutBoundFlight.m
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "OutBoundFlight.h"
#import "Ticket.h"

@interface OutBoundFlight ()

@property (nonatomic) NSDate *primitiveTimeStamp;
@property (nonatomic) NSString *primitiveSectionIdentifier;

@end
@implementation OutBoundFlight

@dynamic airline;
@dynamic arrivalDate;
@dynamic departureDate;
@dynamic destiny;
@dynamic origin;
@dynamic ticket;

-(void) loadFlightDataFromDictionary:(NSDictionary*) dictionary{
    
    self.airline = dictionary[@"airline"];
    
    NSDate *arrival =[self createDateFromStringDate:dictionary[@"departureDate"]  andStringTime:dictionary[@"departureTime"]];// [self createDateFromString:[ self concatDate:dictionary[@"arrivalDate"] withTime:dictionary[@"arrivalTime"]]];

    self.arrivalDate = arrival;
    
    NSDate *departure = [self createDateFromStringDate:dictionary[@"departureDate"]  andStringTime:dictionary[@"departureTime"]];
   //  [self createDateFromString:[ self concatDate:dictionary[@"departureDate"] withTime:dictionary[@"departureTime"]]];
    
    
    self.departureDate = departure;
    self.destiny =dictionary[@"destiny"];
    
    self.origin = dictionary[@"origin"];
}

-(NSString*) concatDate:(NSString*) dateString withTime:(NSString*)timeString {
    
    NSString *newString =[dateString stringByAppendingFormat:@" %@",timeString];
    
    return dateString;
}

-(NSDate*) createDateFromStringDate:(NSString *) dateString andStringTime:(NSString*)timeString{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
   /* [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormat setTimeZone:gmt];
    */
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormat setTimeZone:gmt];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    
    NSArray *tm =[dateString componentsSeparatedByString:@"-"];
    NSArray *hours = [timeString componentsSeparatedByString:@":"];
    
    comp.year = [tm[0] intValue];
    comp.month =[tm[1] intValue];
    comp.day = [tm[2] intValue];
    comp.hour = [hours[0] intValue];
    comp.minute = [hours[1] intValue];
    comp.second = 0;
    NSDate *newDate = [cal dateFromComponents:comp];
    
//    NSDate *newDate= [dateFormat dateFromString:dateString];
    if (newDate == nil) {
        abort();
    }
    return newDate;
}

#pragma mark -Groups timetable
    
- (NSString *)sectionIdentifier
{
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!tmp)
    {
        /*
         Sections are organized by month and year. Create the section identifier as a string representing the number (year * 1000) + month; this way they will be correctly ordered chronologically regardless of the actual name of the month.
         */
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self.departureDate];
        tmp = [NSString stringWithFormat:@"%d", ([components year] * 1000) + [components month]];
    
        [self setPrimitiveSectionIdentifier:tmp];
    }
    return tmp;
}

@end
