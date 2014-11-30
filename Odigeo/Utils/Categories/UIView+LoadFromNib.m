//
//  UIView+LoadFromNib.m
//  ZB4Banking
//
//  Created by Gustavo Pizano on 15.10.2013.
//  Copyright (c) 2013 Zentity a.s. All rights reserved.
//

#import "UIView+LoadFromNib.h"

@implementation UIView (LoadFromNib)

+(id)viewFromNib:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    NSArray *topLevelObjects = [nib instantiateWithOwner:self options:nil];
    UIView * myView = nil;
    for (id topLevelObject in topLevelObjects) {
        if ([topLevelObject isKindOfClass:NSClassFromString(nibName)]) {
            myView = topLevelObject;
            break;
        }
    }
    return myView;
    
}

@end
