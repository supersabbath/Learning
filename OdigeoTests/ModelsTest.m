//
//  ModelsTest.m
//  Odigeo
//
//  Created by Fernando Canon on 29/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XCTestCase+FCPHelper.h"
// SUTs

#import "Ticket.h"
#import "InBoundFlight.h"
#import "OutBoundFlight.h"


//Dependencies
#import "FCPCoreDataStore.h"
@interface ModelsTest : XCTestCase

@property (strong, nonatomic) NSDictionary *testingData;
@property (strong, nonatomic) FCPCoreDataStore *mocStore;

@end

@implementation ModelsTest



- (void)setUp {
    
    [super setUp];
    
    if (!_testingData) { // once
        NSArray *mockData = [ModelsTest loadResourcesFromTestBundle:@"tickets.json"];
        _testingData = mockData.firstObject;
        _mocStore =[FCPCoreDataStore defaultStore];
    
    }
 
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadDataInTicket {
    // This is an example of a functional test case.
    Ticket *sut = [Ticket createManagedObjectInContext:[FCPCoreDataStore privateQueueContext]];
    NSDictionary *d =_testingData[@"price"];
    [sut loadPriceFromDictionary:d];
    
    XCTAssertEqual([sut.amount floatValue], [[NSDecimalNumber decimalNumberWithString:@"856.1307711256048"] floatValue] , @"Should be equal");
   
    XCTAssertTrue([sut.currency isEqualToString:@"EUR"],@"should be EUR");
 
}

- (void)testInBoundFlight {
    
    InBoundFlight *sut = [InBoundFlight createManagedObjectInContext:[FCPCoreDataStore privateQueueContext]];

    [sut loadFlightDataFromDictionary: _testingData[@"inBound"]];
  
    NSString *result= [[sut.arrivalDate description] substringToIndex:16];
 
    BOOL ts= [result isEqualToString:@"2015-03-08 09:25"];
    
    XCTAssertTrue(ts,@"not equal");
 
    XCTAssertTrue([sut.destiny isEqualToString:@"LON"],
                  @"Strings are not equal %@ %@", @"LON", sut.destiny);
    
    XCTAssertTrue([sut.origin isEqualToString:@"PAR"], @"Strings are not equal %@ %@", @"PAR", sut.origin);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormat setTimeZone:gmt];
    
    XCTAssertTrue([sut.departureDate isEqualToDate:[dateFormat dateFromString:@"2015-03-08 02:22"]], @"Dates must be the same");
}

- (void)testOutBoundFlight {
    
    OutBoundFlight *sut = [OutBoundFlight createManagedObjectInContext:[FCPCoreDataStore privateQueueContext]];
    
    [sut loadFlightDataFromDictionary: _testingData[@"outBound"]];
    
    NSString *result= [[sut.arrivalDate description] substringToIndex:16];
    
    BOOL ts= [result isEqualToString:@"2015-02-26 11:08"];
    
    XCTAssertTrue(ts,@"not equal");
    
    XCTAssertTrue([sut.destiny isEqualToString:@"PAR"],
                  @"Strings are not equal %@ %@", @"PAR", sut.destiny);
    
    XCTAssertTrue([sut.origin isEqualToString:@"LON"], @"Strings are not equal %@ %@", @"LON", sut.origin);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormat setTimeZone:gmt];
    
    XCTAssertTrue([sut.departureDate isEqualToDate:[dateFormat dateFromString:@"2015-02-26 09:33"]], @"Dates must be the same");
}


- (void)dtestPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
