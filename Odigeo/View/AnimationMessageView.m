//
//  AnimationMessageView.m
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "AnimationMessageView.h"

#define degreesToRadians(deg) (deg / 180.0 * M_PI)

@interface AnimationMessageView  ()

@property (strong, nonatomic) UIImageView *plane;
@property (assign) float lastAngle;
@property (assign) float radius;
@property (assign) CGPoint expPoint;

-(CGPoint)setPointToAngle:(int)angle center:(CGPoint)centerPoint radius:(double)radios;

@end

@implementation AnimationMessageView


@synthesize radius,expPoint,plane;



- (void) animateArc:(id)view
{
    radius =80;
    self.plane = view;
    int angle = 0; // start angle position 0-360 deg
    CGPoint center = self.plane.center;
    CGPoint start = [self setPointToAngle:angle center:center radius:radius]; //point for start moving
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    
    for(int a =0;a<64;a++) //set path points for 90, 180, 270,360 deg form begining angle
    {
        angle+=5.625;
        expPoint = [self setPointToAngle:angle center:center radius:radius];
        angle+=5.625f;
        
        start = [self setPointToAngle:angle center:center radius:radius];
        
        CGPathAddQuadCurveToPoint(path, nil,expPoint.x, expPoint.y, start.x, start.y);
    }
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.path = path;
    [pathAnimation setCalculationMode:kCAAnimationCubic];
    [pathAnimation setFillMode:kCAFillModeForwards];
    pathAnimation.rotationMode=kCAAnimationRotateAuto ;
    pathAnimation.duration = 20;
    pathAnimation.repeatCount = HUGE_VAL;
    
    
    [plane.layer addAnimation:pathAnimation forKey:nil];
    CGPathRelease(path);
}


-(CGPoint)setPointToAngle:(int)angle center:(CGPoint)centerPoint radius:(double)radios
{
    return CGPointMake(radius*cos(degreesToRadians(angle)) + centerPoint.x, radios*sin(degreesToRadians(angle)) + centerPoint.y);
}



////        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[tpmplane(16)]-0.0-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
////         [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80.0-[tpmplane(14)]" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
//






@end
