//
//  HPNavStyle.m
//  HPNavController
//
//  Created by Hervé PEROTEAU on 14/06/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "HPNavStyle.h"

@implementation HPNavStyle

+(void) setRoundGrayBorder:(UIView *) view {
    
    view.layer.borderColor = [UIColor grayColor].CGColor;
    
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = YES;
}

+(void) hideBorder:(UIView *) view {

    //NSLog(@"%@.hideBorder ...", self.class);
    view.layer.borderColor = [UIColor clearColor].CGColor;
    [view.layer setNeedsDisplay];
    [view.layer displayIfNeeded];
}

+(void) showBorder:(UIView *) view {
    
    //NSLog(@"%@.showBorder ...", self.class);
    view.layer.borderColor = [UIColor grayColor].CGColor;
    [view.layer setNeedsDisplay];
    [view.layer displayIfNeeded];
}

@end
