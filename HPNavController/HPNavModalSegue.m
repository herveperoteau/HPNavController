//
//  HPNavModalSegue.m
//  HPNavController
//
//  Created by Hervé PEROTEAU on 03/09/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "HPNavModalSegue.h"
#import "HPNavController.h"
#import "UIViewController+HPNavController.h"
#import "HPNavItem.h"

@interface HPNavModalSegue ()

@property(nonatomic) BOOL isAnimated;

@end

@implementation HPNavModalSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    
    if ((self=[super initWithIdentifier:identifier source:source destination:destination])) {
        self.isAnimated = YES;
        destination.hpNavItem.popWithGesture = NO;
    }
    
    return self;
}

- (void)perform {
    
    [[self.sourceViewController hpNavController] pushViewController:self.destinationViewController
                                                           animated:self.isAnimated];
}

@end
