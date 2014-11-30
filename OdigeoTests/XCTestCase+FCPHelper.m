//
//  XCTestCase+FCPHelper.m
//  Odigeo
//
//  Created by Fernando Canon on 29/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "XCTestCase+FCPHelper.h"
#import <objc/runtime.h>

@implementation XCTestCase (FCPHelper)

+ (void)swapInstanceMethodsForClass:(Class) cls fromSelector: (SEL)sel1 toSelector: (SEL)sel2
{
    Method method1 = class_getInstanceMethod(cls, sel1);
    Method method2 = class_getInstanceMethod([self class], sel2);
    method_exchangeImplementations(method1, method2);
}


+(id) loadResourcesFromTestBundle:(NSString*) filename{

    NSString *extension = [filename pathExtension];
    
    NSString *name = [filename stringByDeletingPathExtension];
    
    NSString *path =  [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension];
  
    NSError *error;
    
    NSData* data =[[NSData alloc] initWithContentsOfFile:path options:0 error:&error];
    
    NSError *jsonError = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

    if (jsonError && error) {
        NSLog(@"Error in loadResourcesFromTestBundle");
    }
    return  result;
}


@end
