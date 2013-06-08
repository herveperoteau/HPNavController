//
//  HPCellMenuCell.m
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 27/03/13.
//  Copyright (c) 2013 Herv√© PEROTEAU. All rights reserved.
//

#import "HPCellMenuItem.h"
#import "HPNavController.h"

#define OFFSETX_ICON 10  // a partir du bord
#define OFFSETX_TEXT 10  // apres l'icon
#define SPACE_AFTER_TITLE 60  // place dispo apres le texte


@implementation HPCellMenuItem {
    
    UILabel *labelTitle;
    UILabel *labelQuantity;
    UIImageView *imageViewIcon;
}

-(void) initializeContentView {
    
    if (labelTitle!=nil) {
        
        return;
    }
    
    //NSLog (@"%@.initializeContentView ...", self.class);

    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    self.imageView.image = nil;
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.adjustsFontSizeToFitWidth = YES;
    labelTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.contentView addSubview:labelTitle];
    
    labelQuantity = [[UILabel alloc] initWithFrame:CGRectZero];
    labelQuantity.backgroundColor = [UIColor clearColor];
    labelQuantity.textColor = [UIColor whiteColor];
    labelQuantity.font = [UIFont systemFontOfSize:14];
    labelQuantity.adjustsFontSizeToFitWidth = YES;
    labelQuantity.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    labelQuantity.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:labelQuantity];
    
    imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageViewIcon.contentMode = UIViewContentModeScaleAspectFill;
    imageViewIcon.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:imageViewIcon];
    
}

-(void) awakeFromNib {
    
    //NSLog (@"%@.awakeFromNib ...", self.class);
    
    [super awakeFromNib];
    
    [self initializeContentView];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //NSLog (@"%@.initWithStyle ...", self.class);

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // Initialization code
        [self initializeContentView];
    }
    
    return self;
}


- (void)layoutSubviews
{
    //NSLog (@"%@.layoutSubviews ...", self.class);

	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	
	//NSLog (@"%@.layoutSubviews bounds size %f * %f", self.class, contentRect.size.width, contentRect.size.height);
	
    // Positionnement de l'icon
    
    CGFloat x = OFFSETX_ICON;
    CGFloat y = (contentRect.size.height - self.heightIcon) / 2;
    CGFloat w = self.heightIcon;
    CGFloat h = self.heightIcon;
    
    CGRect frame = CGRectMake(x, y, w, h);
    //NSLog (@"%@.layoutSubviews icon (%f, %f) (%f x %f)", self.class, x, y, w, h);
    
    imageViewIcon.frame = frame;
    
    // Positionnement du text
    
    x = frame.origin.x + frame.size.width + OFFSETX_TEXT;
    y = 0;
    w = (contentRect.size.width - kVisiblePartOfRootWhenDisplayMenu) - x - SPACE_AFTER_TITLE;
    h = contentRect.size.height;
    
    frame = CGRectMake(x, y, w, h);
    
    //NSLog (@"%@.layoutSubviews title (%f, %f) (%f x %f)", self.class, x, y, w, h);
    
    labelTitle.frame = frame;
    
    // positionnement de la quantity
    
    x = frame.origin.x + frame.size.width + OFFSETX_TEXT;
    y = 0;
    w = (contentRect.size.width - kVisiblePartOfRootWhenDisplayMenu) - x - OFFSETX_TEXT;
    h = contentRect.size.height;

    frame = CGRectMake(x, y, w, h);
    
    //NSLog (@"%@.layoutSubviews title (%f, %f) (%f x %f)", self.class, x, y, w, h);
    
	labelQuantity.frame = frame;
}

-(void) dealloc {
    
   // NSLog (@"%@.dealloc ...", self.class);
}

-(void) setTextColor:(UIColor *)color {
    
   // NSLog (@"%@.setTextColor ...", self.class);
    
    _textColor = color;
    
    [labelTitle setTextColor:color];
    [labelQuantity setTextColor:color];
}

-(void) setTextSelectedColor:(UIColor *)color {
    
    //NSLog (@"%@.setTextSelectedColor ...", self.class);
    
    _textSelectedColor = color;
}

-(void) setFontTitle:(UIFont *) font {
    
    //NSLog (@"%@.setFont ...", self.class);
    
    _fontTitle = font;

    [labelTitle setFont:font];
}

-(void) setFontQuantity:(UIFont *)fontQuantity {
    
    _fontQuantity = fontQuantity;
    
    [labelQuantity setFont:fontQuantity];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //NSLog (@"%@.setSelected(%d) %@ ...", self.class, selected, labelTitle.text);

    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        
        [labelTitle setTextColor:_textSelectedColor];
        [labelQuantity setTextColor:_textSelectedColor];
    }
    else {
        
        [labelTitle setTextColor:_textColor];
        [labelQuantity setTextColor:_textColor];
    }
}

- (void)prepareForReuse {
    
    [super prepareForReuse];

    //NSLog (@"%@.prepareForReuse(%@) ...", self.class, labelTitle.text);

    labelTitle.text = nil;
    labelQuantity.text = nil;
    imageViewIcon.image = nil;
}

-(void) configureWithTitle:(NSString *) title
                  quantity:(NSString *) quantity
                      icon:(UIImage *) icon {
    
    //NSLog (@"%@.configureWithTitle(title=%@, quantity=%@) ...", self.class, title, quantity);

    labelTitle.text = title;
    labelQuantity.text = quantity;
    imageViewIcon.image = icon;
}


@end



