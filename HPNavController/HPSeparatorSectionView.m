//
//  HPSeparatorSectionView.m
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 26/03/13.
//  Copyright (c) 2013 Herv√© PEROTEAU. All rights reserved.
//

#import "HPSeparatorSectionView.h"
#import "HPNavController.h"

@implementation HPSeparatorSectionView

- (id)initWithWidth:(CGFloat) width
{
    CGRect frame = CGRectMake(0, 0, width, kHeightSeparatorMenu);
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
	// Since we use the CGContextRef a lot, it is convienient for our demonstration classes to do the real work
	// inside of a method that passes the context as a parameter, rather than having to query the context
	// continuously, or setup that parameter for every subclass.
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawInContext:(CGContextRef)context
{
    // Preserve the current drawing state
	CGContextSaveGState(context);

    // Drawing lines gris foncé
	CGContextSetRGBStrokeColor(context, 27.0/255.0, 29.0/255.0, 33.0/255.0, 1.0);
    
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.0);
	
	// Draw a single line from left to right
    
    CGFloat y = 1;
    CGFloat xOffset = 10.0;
    
	CGContextMoveToPoint(context, xOffset, y);
	CGContextAddLineToPoint(context, self.frame.size.width - kVisiblePartOfRootWhenDisplayMenu - xOffset, y);
	CGContextStrokePath(context);
    
    // Drawing lines gris claire
	CGContextSetRGBStrokeColor(context, 41.0/255.0, 45.0/255.0, 50.0/255.0, 1.0);
    
	CGContextMoveToPoint(context, xOffset, y+1);
	CGContextAddLineToPoint(context, self.frame.size.width - kVisiblePartOfRootWhenDisplayMenu - xOffset, y+1);
	CGContextStrokePath(context);
    
    // Restore the previous drawing state.
	CGContextRestoreGState(context);

}

@end
