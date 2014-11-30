//
//  WSManager.m
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "WSManager.h"

@implementation WSManager

- (void)fetchFlightsforURL:(NSURL*) serviceURL withCompletionBlock:(WSManagerCompletionBlock) block{
 
    
    [[[NSURLSession sharedSession] dataTaskWithURL:serviceURL completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) { // aqui podriamos controlar los errores http, o no connection
            NSLog(@"error: %@", error.localizedDescription);
            block(nil,error);
            return;
        }
        
        NSError *jsonError = nil;
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if ([result isKindOfClass:[NSArray class]]) {
        
            block(result, nil);
        }
        
    }] resume];
}

@end
