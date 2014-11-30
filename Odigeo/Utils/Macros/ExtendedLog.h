//
//  ExtendedLog.h
//  Skoda
//
//  Created by Fernando Canon on 01/07/14.
//  Copyright (c) 2014 Zentity a.s. All rights reserved.

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define NSLog(x...) ExtendDontNSLog();
#endif

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);
void ExtendDontNSLog();