//
//  currencyServiceTest.m
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
// SUT
#import "WSCurrencyConverter.h"


@interface currencyServiceTest : XCTestCase{
    WSCurrencyConverter *sut;
}

@end

@implementation currencyServiceTest

- (void)setUp {
    
    [super setUp];
    
    sut = [[WSCurrencyConverter alloc] initWithServiceURL:@"http://rate-exchange.appspot.com/currency"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnection {
    
      XCTestExpectation *readJson = [self expectationWithDescription:@"http USDollars"];
    [sut fetchCurrencyConvertionRate:@"USD" withCompletionBlock:^(NSDictionary *rates, NSError *error) {
       
        XCTAssert([rates isKindOfClass:[NSDictionary class]], @"Not a dictionary");
        [readJson fulfill];
        
        id testval =rates[@"USD"];
        XCTAssertNotNil(testval, @"shouldn't be nill");
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error timeout");
    
    }];
}

-(void) testCache
{
    
    NSArray *testData = @[@"USD",@"GBP",@"JPY",@"USD",@"GBP",@"JPY"];
    NSMutableArray *testResutls =[@[] mutableCopy];
    
    
    NSMutableArray *cachesLogs=[@[] mutableCopy];
    
    
    XCTestExpectation *readJson = [self expectationWithDescription:@"http USDollars"];
    
    [testData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSLog(@"feching for %@", obj);
        
        [sut fetchCurrencyConvertionRate:obj withCompletionBlock:^(NSDictionary *rates, NSError *error) {
            
            if (error) {
                XCTFail(@"error");
            }
                
            
            
            XCTAssertNotNil(rates, @"shouldn't be nill");
           
            [testResutls addObject:@"rate"];
        
       
            if (rates[@"cache"]) {
                [cachesLogs addObject:@"log"];
            }
            if (testData.count == testResutls.count) {
                XCTAssertFalse(cachesLogs.count == 3, "at least 3 logs");
                [readJson fulfill];
            }
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error timeout");
        
    }];
   ;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
