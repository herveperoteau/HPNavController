//
//  HPNavItemController.h
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 12/03/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

@interface HPNavItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL visiblePartialOverMenuView;

-(UIView *) containerView;
-(void) setContainerView:(UIView *) view;

-(void) addMaskView;
-(void) setOpacityMaskView:(float)opacity;
-(void) removeMaskView;


@end
