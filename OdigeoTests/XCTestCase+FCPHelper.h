//
//  XCTestCase+FCPHelper.h
//  Odigeo
//
//  Created by Fernando Canon on 29/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

typedef void(^RequestCompletion)(id  object, NSError * error);

@interface XCTestCase (FCPHelper)

+(id) loadResourcesFromTestBundle:(NSString*) filename;

+ (void)swapInstanceMethodsForClass:(Class) cls fromSelector: (SEL)sel1 toSelector: (SEL)sel2;

@end
