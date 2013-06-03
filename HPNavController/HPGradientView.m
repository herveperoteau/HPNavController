//
//  GradientView.m
//  StoreSearch
//
//  Created by Hervé PEROTEAU on 02/02/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "HPGradientView.h"

@implementation HPGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    const CGFloat components[8] = {0.0f, 0.0f, 0.0f, 0.45f, 0.0f, 0.0f, 0.0f, 0.9f};
    const CGFloat locations[2] = {0.0f, 1.0f};
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 2);
    CGColorSpaceRelease(space);

    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    CGPoint point = CGPointMake(x, y);
    CGFloat radius = MAX(x, y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

-(void) dealloc {
    
    //NSLog(@"%@.dealloc", self.class);
}

@end
