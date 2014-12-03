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
#import "WSCurrencyConverter.h"

#import "XCTestCase+FCPHelper.h"

@interface FCPCoreDataImporterTests : XCTestCase

@property (strong, nonatomic) FCPCoreDataStore *mocStore;
@property (strong, nonatomic) FCPCoreDataImporter *sut;
@property (strong, nonatomic) WSManager *mockManager ;
@property (strong, nonatomic) WSCurrencyConverter *mockWSCurrencyConverte;


@end


@implementation FCPCoreDataImporterTests

- (void)setUp {
    
    [super setUp];
    _mocStore =[FCPCoreDataStore defaultStore];

    // change the method implementation at runtime.. to manually create a mock object for WSmanager
    SEL realMethod =  NSSelectorFromString(@"fetchFlightsforURL:withCompletionBlock:");
    SEL fakeMethod = NSSelectorFromString(@"fakeMethodImplementation:withCompletion:");  // see method below
    [FCPCoreDataImporterTests swapInstanceMethodsForClass:[WSManager class] fromSelector:realMethod toSelector:fakeMethod];
   
    SEL realMethodForCurrencyConvertor =  NSSelectorFromString(@"fetchCurrencyConvertionRate:withCompletionBlock:");
    SEL fakeMethodCurrencyConvertor = NSSelectorFromString(@"fakeCurrencyConvererMethodImplementation:withCompletion:");  // see method below
    [FCPCoreDataImporterTests swapInstanceMethodsForClass:[WSCurrencyConverter class] fromSelector:realMethodForCurrencyConvertor toSelector:fakeMethodCurrencyConvertor];
    
   // create the mocks
    _mockManager= [[WSManager alloc] init];
    _mockWSCurrencyConverte = [[WSCurrencyConverter alloc] init];
  
    
 
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testImport {
    
    
    XCTestExpectation *coreDataOperation = [self expectationWithDescription:@"coredata request"];
   

     // given
    _sut = [[FCPCoreDataImporter alloc] initWithContext:[FCPCoreDataStore privateQueueContext] webservice:_mockManager andWSCurrency:_mockWSCurrencyConverte];
    
    [_sut import];
    
    
    [[FCPCoreDataStore privateQueueContext] performBlock:^{
      
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
        
        NSArray* results = [[FCPCoreDataStore privateQueueContext] executeFetchRequest:fetchRequest
                                                                                 error:nil];
        
        XCTAssertTrue(results.count == 538,@" result count == %lu should be 538",(unsigned long)results.count);
        
        XCTAssertTrue([results.firstObject isKindOfClass:NSClassFromString(@"Ticket")],@"Ticket class");
        
     
        
        //Clear the test:: NOTE:: not needed see TDD flag on arguments
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [[FCPCoreDataStore privateQueueContext] deleteObject:obj];
            
        }];
        [[FCPCoreDataStore privateQueueContext] save:nil]; // remove from presistence store
           [coreDataOperation fulfill];
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


-(void) fakeCurrencyConvererMethodImplementation:(NSString *)rate withCompletion:(RequestCompletion)block {

    //#warning OJO esto esta asi porque falla el servicio
      block(@{@"USD":@"1.0000",@"cache":@"true"} , nil);
}
/*
    this test should no be here .. its task is to test the request used in AirLinesListTableViewController
 */
- (void)testAirlineSort
{
 
    XCTestExpectation *coreDataOperation = [self expectationWithDescription:@"coredata request"];

    // given
    _sut = [[FCPCoreDataImporter alloc] initWithContext:[FCPCoreDataStore privateQueueContext] webservice:_mockManager andWSCurrency:_mockWSCurrencyConverte];
    
    [_sut import];
    
    [[FCPCoreDataStore privateQueueContext] performBlock:^{
    
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"airline"
                                                                       ascending:YES];
        
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                                  @"SELF inBoundFlight != nil"];
//        [fetchRequest setPredicate:predicate];
        [fetchRequest setResultType:NSDictionaryResultType];
        [fetchRequest setReturnsDistinctResults:YES];
        [fetchRequest setPropertiesToFetch:@[@"airline"]];


        NSError *error;
        NSArray* results = [[FCPCoreDataStore privateQueueContext] executeFetchRequest:fetchRequest
                                                                                 error:&error];
       
        if (results == nil) {
            NSLog(@"%@", [error.userInfo debugDescription]);
        }

        // then
        
            XCTAssertTrue(results.count == 5,@" result count == %lu should be 538",(unsigned long)results.count);
  
            XCTAssertTrue([[[results firstObject] allKeys] firstObject],@"USD should be: %@ ",[[[results firstObject] allKeys] firstObject]);
        
   
        
        //Clear the test:: NOTE:: not needed see TDD flag on arguments
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [[FCPCoreDataStore privateQueueContext] deleteObject:obj];
             [[FCPCoreDataStore privateQueueContext] save:nil];
        }];
        // remove from presistence store
        
        [coreDataOperation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:50 handler:^(NSError *error) {
        
        if (error) {
            NSLog(@" %@", [[error userInfo] debugDescription]);
        }else
            NSLog(@"Terminado testAirlineSort");
        
    }];
 
}

@end
