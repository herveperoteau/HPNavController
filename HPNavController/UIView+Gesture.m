//
//  UIView+Gesture.m
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 21/03/13.
//  Copyright (c) 2013 Herv√© PEROTEAU. All rights reserved.
//

#import "UIView+Gesture.h"

@implementation UIView (Gesture)

-(void) removeAllGestureRecognizer {
    
    for (UIGestureRecognizer *gestureRecognizer in [self.gestureRecognizers copy]) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
}

@end
