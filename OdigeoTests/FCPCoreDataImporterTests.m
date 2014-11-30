//
//  OdigeoTests.m
//  OdigeoTests
//
//  Created by Fernando Canon on 27/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

//SUT
#import "FCPCoreDataImporter.h"

//Dependencie
#import "FCPCoreDataStore.h"
#import "WSManager.h"

#import "XCTestCase+FCPHelper.h"

@interface FCPCoreDataImporterTests : XCTestCase

@property (strong, nonatomic) FCPCoreDataStore *mocStore;
@property (strong, nonatomic) FCPCoreDataImporter *sut;
@property (strong, nonatomic) WSManager *mockManager ;

@end


@implementation FCPCoreDataImporterTests

- (void)setUp {
    
    [super setUp];
    _mocStore =[FCPCoreDataStore defaultStore];
   
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testImport {
    
    
    XCTestExpectation *coreDataOperation = [self expectationWithDescription:@"coredata request"];
   
    // given
    SEL realMethod =  NSSelectorFromString(@"fetchFlightsforURL:withCompletionBlock:");
    SEL fakeMethod = NSSelectorFromString(@"fakeMethodImplementation:withCompletion:");  // see method below
    
    [FCPCoreDataImporterTests swapInstanceMethodsForClass:[WSManager class] fromSelector:realMethod toSelector:fakeMethod];
    
    //then
    _mockManager= [[WSManager alloc] init];
    
    
    _sut = [[FCPCoreDataImporter alloc] initWithContext:[FCPCoreDataStore privateQueueContext] webservice:_mockManager];
    
    [_sut import];
    
    
    [[FCPCoreDataStore privateQueueContext] performBlock:^{
      
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
        
        NSArray* results = [[FCPCoreDataStore privateQueueContext] executeFetchRequest:fetchRequest
                                                                                 error:nil];
        
        XCTAssertTrue(results.count == 538,@" result count == %lu should be 538",(unsigned long)results.count);
        
        XCTAssertTrue([results.firstObject isKindOfClass:NSClassFromString(@"Ticket")],@"Ticket class");
        
        [coreDataOperation fulfill];
        
        //Clear the test:: NOTE:: not needed see TDD flag on arguments
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [[FCPCoreDataStore privateQueueContext] deleteObject:obj];
            
        }];
        [[FCPCoreDataStore privateQueueContext] save:nil]; // remove from presistence store
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
        if (error) {
            NSLog(@" %@", [[error userInfo] debugDescription]);
        }else
            NSLog(@"Terminado testImport");
        

     
    }];
    
}

//    [_mockManager fetchFlightsforURL:nil withCompletionBlock:^(NSArray *tickets, NSError *error) {
//        NSLog(@"method swaping is good");
//    }];

-(void) fakeMethodImplementation:(NSString*)s withCompletion:(RequestCompletion)block {
    
    NSArray *mockData = [FCPCoreDataImporterTests loadResourcesFromTestBundle:@"tickets.json"];
    block(mockData, nil);
}
//- (void)testPerformanceExample {
//
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
