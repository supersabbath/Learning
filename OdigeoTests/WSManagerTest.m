//
//  WSManagerTest.m
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


//SUT
#import "WSManager.h"


//Dependecies for D. Inyection
@interface WSManagerTest : XCTestCase


@end

@implementation WSManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testGETWsManager
{
     // given
    WSManager *wsManager =[[WSManager alloc] init];

    XCTestExpectation *readJson = [self expectationWithDescription:@"http connexion"];

    // when
    NSURL *serviceURL =[NSURL URLWithString:@"http://odigeo-iostest.herokuapp.com/flight"];
    [wsManager fetchFlightsforURL:serviceURL withCompletionBlock:^(NSArray *tickets, NSError *error) {
        
        XCTAssertNil(error,@"something fail");
        
        if (tickets) {
            XCTAssertFalse([readJson isKindOfClass:[NSArray class]],@"The service should return and arrar");
            [readJson fulfill];
        }
    }];
    // then
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
       
        NSLog(@"Terminado testGETWsManager");
    }];
}




 


@end
