//
//  WSManager.h
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//
// NOTE:: El nombre de esta clase, usa WS. Según las buenas prácticas de Objective-C no se debe usar iniciales..
// Pero el acrónimo WS es muy reconocido en la industria.


#import <Foundation/Foundation.h>

typedef void(^WSManagerCompletionBlock)(NSArray * tickets, NSError * error);

@interface WSManager : NSObject


- (void)fetchFlightsforURL:(NSURL*) serviceURL withCompletionBlock:(WSManagerCompletionBlock) block;

@end
