//
//  HPNavPushSegue.m
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 12/03/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "HPNavPushSegue.h"
#import "HPNavController.h"

@implementation HPNavPushSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    
    if ((self=[super initWithIdentifier:identifier source:source destination:destination])) {
        self.isAnimated = YES;
    }
    
    return self;
}

- (void)perform {
    
    [[self.sourceViewController hpNavController] pushViewController:self.destinationViewController
                                                           animated:self.isAnimated];
}

@end
