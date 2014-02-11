//
//  HPNavItemController.m
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 12/03/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HPNavItem.h"
#import "HPGradientView.h"

@implementation HPNavItem {

    UIView *containerView;
    HPGradientView *maskContainerView;
}

-(id) init {

    if ( (self = [super init]) ) {
        
        self.popWithGesture = YES;
    }
    
    return self;
}

//-(void) dealloc {
//        
//    NSLog(@"%@.dealloc (%@)", self.class, self.title);
//}

-(UIView *) containerView {

    return containerView;
}

-(void) setContainerView:(UIView *) view {
    
    containerView = view;
}

-(void) addMaskView {
    
    if (maskContainerView == nil) {
        
        NSAssert(containerView!=nil, @"ContainerView not exist !!!");
        
        //NSLog(@"addMaskView containerView.bounds (%f,%f) (%fx%f)", containerView.bounds.origin.x, containerView.bounds.origin.y,
        //      containerView.bounds.size.width, containerView.bounds.size.height);

        maskContainerView = [[HPGradientView alloc] initWithFrame:containerView.bounds];
        maskContainerView.layer.opacity = 0.0f;
        
        [containerView addSubview:maskContainerView];
    }
}

-(void) setOpacityMaskView:(float)opacity {
    
    [self addMaskView];
    maskContainerView.layer.opacity = opacity;
}

-(void) removeMaskView {
    
    if (maskContainerView != nil) {
        
        [maskContainerView removeFromSuperview];
        maskContainerView = nil;
    }
}

@end
