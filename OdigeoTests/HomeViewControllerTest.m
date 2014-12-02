//
//  TicketsTableVCTest.m
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
//sut
#import "HomeViewController.h"

//DY
 
@interface HomeViewControllerTest : XCTestCase {
    HomeViewController*sut;
}

@end

@implementation HomeViewControllerTest

- (void)setUp {
    [super setUp];
    sut = [[HomeViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAirlinesButton_ShouldBeConnected
{
    // given
    [sut view];
    
    // then
    XCTAssertNotNil(sut.airLinesBTN, @"should be connected");
}


- (void)testTimeTableBTN_ShouldBeConnected
{
    // given
    [sut view];
    
    // then
    XCTAssertNotNil(sut.timeTableBTN, @"should be connected");
}

- (void)testTimeTableButtonAction
{
    // when
    [sut view];
    

    // then
    UIButton *button = [sut timeTableBTN];
   
    
    XCTAssertTrue([[[button actionsForTarget:sut forControlEvent:UIControlEventTouchUpInside] firstObject] isEqualToString:@"presentTimeTablesLIst:"]);
}

- (void)testAirlinesButtonAction
{
    // when
    [sut view];
    
    // then
    UIButton *button = [sut airLinesBTN];
    
    XCTAssertTrue([[[button actionsForTarget:sut forControlEvent:UIControlEventTouchUpInside] firstObject] isEqualToString:@"presentAirlinesList:"]);
}


@end
