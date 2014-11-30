//
//  NSFileManager+TBDirectories.h
//  
//
//  Created by Theodore Calmes on 1/17/14.
//  Copyright (c) 2014 thoughtbot. All rights reserved.
//
//  Edited by Fernando Cañón


@import Foundation;

@interface NSFileManager (TBDirectories)

+ (NSURL *)appLibraryDirectory;
+ (NSURL *) applicationDocumentsDirectory ;

@end
