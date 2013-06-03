//
//  HPCellMenuCell.h
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 27/03/13.
//  Copyright (c) 2013 Herv√© PEROTEAU. All rights reserved.
//

@interface HPCellMenuItem : UITableViewCell

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textSelectedColor;
@property (nonatomic, strong) UIFont *fontTitle;
@property (nonatomic, strong) UIFont *fontQuantity;
@property (nonatomic, assign) NSInteger heightIcon;

-(void) configureWithTitle:(NSString *) title
                  quantity:(NSString *) quantity
                      icon:(UIImage *) icon;

@end
