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

@end
