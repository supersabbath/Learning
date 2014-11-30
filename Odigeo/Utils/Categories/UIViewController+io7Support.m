//
//  UIViewController+io7Support.m
//  Skoda
//
//  Created by Gustavo Pizano on 8.04.2014.
//  Copyright (c) 2014 Zentity a.s. All rights reserved.
//

#import "UIViewController+io7Support.h"
#import "Macros.h"

@implementation UIViewController (io7Support)



- (void) configureEdgeLayout
{
    if(IS_IOS7){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}



-(void) addObserver:(UIViewController*) observer forNotification:(NSString *) notificationName withCallbackSelector:(SEL) callbackMethod
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:callbackMethod
     name:notificationName
     object:nil];
}


- (void) stopObservingSALocaliztionNotifications
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self ];

}


-(void) showAlertMessage:(NSString*) message forDelegate:(id) delegate
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_MESSAGE_TITLE_KEY", nil)
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:NSLocalizedString(@"OK_KEY",nil)
                                          otherButtonTitles:nil];
    [alert show];

}
@end
