//
//  AppDelegate.h
//  Odigeo
//
//  Created by Fernando Canon on 27/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//


@import CoreData;
@import Foundation;

@interface FCPCoreDataStore : NSObject

+ (instancetype)defaultStore;

+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)privateQueueContext;

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString;
 

@end

