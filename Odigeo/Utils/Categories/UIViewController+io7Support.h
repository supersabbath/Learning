//
//  UIViewController+io7Support.h
//  Skoda
//
//  Created by Gustavo Pizano on 8.04.2014.
//  Copyright (c) 2014 Zentity a.s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (io7Support)

- (void) configureEdgeLayout;

-(void) addObserver:(UIViewController*) observer forNotification:(NSString *) notificationName withCallbackSelector:(SEL) callbackMethod;

- (void) stopObservingSALocaliztionNotifications;

-(void) showAlertMessage:(NSString*) message forDelegate:(id) delegate;
@end