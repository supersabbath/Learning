//
//  Constants.h
//  Put here all you literals and defined  costants
//
//  Created by Fernando Canon on 09/04/14.
//  Copyright (c) 2014 Zentity a.s. All rights reserved.
//

#ifndef _Constants_h
#define _Constants_h

extern NSString* OdigeErrorDomain;
extern NSString *OdigeServiceURL;
extern NSString * kGoogleSDKAPIKey; // these two could be the same KEY. Depends on your configuration
extern NSString *currencySerciveURL;

typedef enum : NSUInteger {
    OdigeoUnknownError,
    OdigeoAnotherError,
 
} OdigepErrorCode;

#endif

