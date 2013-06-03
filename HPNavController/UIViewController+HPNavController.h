//
//  UIViewController+HPNavController.h
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 12/03/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

@class HPNavController;
@class HPNavItem;

@interface UIViewController (HPNavController)

@property(nonatomic, readonly, strong) HPNavController *hpNavController;
@property(nonatomic, readonly, strong) HPNavItem *hpNavItem;

@end
