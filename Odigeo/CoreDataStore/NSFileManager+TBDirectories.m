//
//  NSFileManager+TBDirectories.m
//  
//
//  Created by Theodore Calmes on 1/17/14.
//  Copyright (c) 2014 thoughtbot. All rights reserved.
//
//  Edited by Fernando Cañón
//

#import "NSFileManager+TBDirectories.h"

@implementation NSFileManager (TBDirectories)

+ (NSURL *)appLibraryDirectory
{
    return [[[self defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *) applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.fcp.odigeo.Odigeo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
