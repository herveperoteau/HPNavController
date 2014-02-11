//
//  HPNavController.h
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 12/03/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "UIViewController+HPNavController.h"
#import "UIView+Gesture.h"

#define kVisiblePartOfRootWhenDisplayMenu 38
#define kHeightMenuRow 39
#define kHeightMenuRowIcon 22


@interface HPNavController : UIViewController

@property(nonatomic, readonly) NSArray *viewControllers;
@property(nonatomic, readonly) UIViewController *topViewController;
@property(nonatomic, readonly) UIViewController *focusedViewController;

-(id) initWithRootViewController:(UIViewController *)rootViewController;
-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
-(UIViewController *) popViewControllerAnimated:(BOOL)animated;
-(void) accesDirectMenu:(id) sender;

#pragma mark - Gestion du Menu

-(id) initWithRootViewController:(UIViewController *)rootViewController
           andMenuViewController:(UIViewController *)menuViewController
                     iconBtnMenu:(UIImage *)iconMenu
             iconBtnMenuSelected:(UIImage *)iconMenuSelected
        directAccesMenuPermanent:(BOOL) flagDirectAccesMenuPermanent;


@end
