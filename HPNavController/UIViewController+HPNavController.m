//
//  UIViewController+HPNavController.m
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 12/03/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//


#import <objc/runtime.h>

#import "UIViewController+HPNavController.h"
#import "HPNavItem.h"
#import "HPNavController.h"

static void * const kHPNavigationControllerStorageKey = (void*)&kHPNavigationControllerStorageKey;
static void * const kHPNavigationItemStorageKey = (void*)&kHPNavigationItemStorageKey;

@implementation UIViewController (HPNavController)

- (HPNavController *)hpNavController {
    
    UIViewController *cur = self;
    HPNavController *result;
    
    while (cur != nil && result == nil) {
        
        result = objc_getAssociatedObject(cur, kHPNavigationControllerStorageKey);
        cur = cur.parentViewController;
    }
    
    return result;
}

-(void) removeHPNavController {
    
    id navController = objc_getAssociatedObject(self, kHPNavigationControllerStorageKey);
    if (navController)
        objc_setAssociatedObject(self, kHPNavigationControllerStorageKey, nil, OBJC_ASSOCIATION_ASSIGN);
    
    id navItem = objc_getAssociatedObject(self, kHPNavigationItemStorageKey);
    if (navItem)
        objc_setAssociatedObject(self, kHPNavigationControllerStorageKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setHPNavController:(HPNavController *)hpNavController {

    objc_setAssociatedObject(self, kHPNavigationControllerStorageKey, hpNavController, OBJC_ASSOCIATION_ASSIGN);
}

- (HPNavItem *)hpNavItem {
    
    HPNavItem *result = objc_getAssociatedObject(self, kHPNavigationItemStorageKey);
   
    if (!result) {
        
        result = [[HPNavItem alloc] init];
        objc_setAssociatedObject(self, kHPNavigationItemStorageKey, result, OBJC_ASSOCIATION_RETAIN);
    }
    
    return result;
}


@end
