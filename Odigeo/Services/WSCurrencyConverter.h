//
//  WSCurrencyConverter.h
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "WSManager.h"
typedef void(^WSCurrencyCompletion)(NSDictionary * rates, NSError * error);
@interface WSCurrencyConverter : NSObject

@property (strong,nonatomic) NSString *serviceURL;

- (instancetype)initWithServiceURL:(NSString*)urlString;
/*
 *  Fetch currency converions from EURO to a given Currency this call will execute a background thread
    in a serial queue
 *  @params currency : currency
 *  @Returns @{"USD":0.234234234}
*/

- (void)fetchCurrencyConvertionRate:(NSString*)currency  withCompletionBlock:(WSCurrencyCompletion) block;
@end
