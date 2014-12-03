//
//  Flight.m
//  Odigeo
//
//  Created by Fernando Canon on 03/12/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "Flight.h"
#import "Ticket.h"

@interface Flight ()

@property (nonatomic) NSDate *primitiveTimeStamp;
@property (nonatomic) NSString *primitiveSectionIdentifier;

@end

@implementation Flight

@synthesize primitiveSectionIdentifier, primitiveTimeStamp;

@dynamic airline;
@dynamic arrivalDate;
@dynamic departureDate;
@dynamic destiny;
@dynamic origin;
@dynamic sectionIdentifier;
@dynamic isInBound;
@dynamic ticket;



-(void) loadFlightDataFromDictionary:(NSDictionary*) dictionary{
    
    self.airline = dictionary[@"airline"];
    
    NSDate *arrival = [self createDateFromDateString:dictionary[@"arrivalDate"] andHours:dictionary[@"arrivalTime"]];
    
    self.arrivalDate = arrival;
    NSDate *departure =  [self createDateFromDateString:dictionary[@"departureDate"] andHours:dictionary[@"departureTime"]];
    
    self.departureDate=departure;
    self.destiny =dictionary[@"destiny"];
    
    self.origin = dictionary[@"origin"];
}


-(NSDate*) createDateFromDateString:(NSString *) dateString andHours:(NSString*) time {
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormat setTimeZone:gmt];
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    
    NSArray *tm =[dateString componentsSeparatedByString:@"-"];
    NSArray *hours = [time componentsSeparatedByString:@":"];
    
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

// not use
-(NSString*) concatDate:(NSString*) dateString withTime:(NSString*)timeString {
    
    NSString *newString =[dateString stringByAppendingFormat:@" %@",timeString];
    
    return newString;
}

#pragma mark -Groups section identifier

- (NSString *)sectionIdentifier
{
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!tmp)
    {
   
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[self departureDate]];
        
        NSInteger hour = [components hour];
      
        if(hour >= 0 && hour < 12){
            tmp = [NSString stringWithFormat:@"%d-%d-%d-0",[components year],[components month],[components day]];
        }
        else if(hour >= 12 && hour < 17){
              tmp = [NSString stringWithFormat:@"%d-%d-%d-1",[components year],[components month],[components day]];
        }
            
        else if(hour >= 17){
            tmp = [NSString stringWithFormat:@"%d-%d-%d-2",[components year],[components month],[components day]];
        }
        
        [self setPrimitiveSectionIdentifier:tmp];
    
        
    }
    return tmp;

}

@end
