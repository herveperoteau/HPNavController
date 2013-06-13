//
//  HPStatusBar.m
//
//  Created by Herve Peroteau
//  Copyright 2013 Herve Peroteau. All rights reserved.
//

#import "HPStatusBar.h"

@interface HPStatusBar ()
    @property (nonatomic, strong, readonly) UIWindow *overlayWindow;
    @property (nonatomic, strong, readonly) UIView *topBar;
    @property (nonatomic, strong) UILabel *stringLabel;
    @property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation HPStatusBar
    
@synthesize topBar, overlayWindow, stringLabel, activityIndicator;

+ (HPStatusBar*)sharedView {
    
    static dispatch_once_t once;
    static HPStatusBar *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[HPStatusBar alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

+ (void)showSuccessWithStatus:(NSString*)status
{
    [HPStatusBar showWithStatus:status];
    
    [[HPStatusBar sharedView] performSelector:@selector(dismiss:)
                                   withObject:status
                                   afterDelay:2.0 ];
}

+ (void)showWithStatus:(NSString*)status {

    [HPStatusBar showWithStatus:status withActivityIndicator:NO];
}

+ (void)showWithStatus:(NSString*)status withActivityIndicator:(BOOL)withActivityIndicator {
    
    UIColor *barColor = [UIColor clearColor];
    UIColor *textColor = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    [[HPStatusBar sharedView] showWithStatus:status
                                    barColor:barColor
                                   textColor:textColor
                           activityIndicator:withActivityIndicator];
}

+ (void)showErrorWithStatus:(NSString*)status {
    
    UIColor *barColor = [UIColor colorWithRed:97.0/255.0 green:4.0/255.0 blue:4.0/255.0 alpha:1.0];
    UIColor *textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    [[HPStatusBar sharedView] showWithStatus:status
                                    barColor:barColor
                                   textColor:textColor
                           activityIndicator:NO];

    [[HPStatusBar sharedView] performSelector:@selector(dismiss:)
                                   withObject:status
                                   afterDelay:2.0 ];
}

+ (void)dismiss {
    
    [[HPStatusBar sharedView] dismiss:nil];
}

+ (void)dismiss:(NSString *)status {

    [[HPStatusBar sharedView] dismiss:status];
}

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
        
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

- (void)showWithStatus:(NSString *)status barColor:(UIColor*)barColor textColor:(UIColor*)textColor activityIndicator:(BOOL)withActivityIndicator{
    
    [HPStatusBar cancelPreviousPerformRequestsWithTarget:[HPStatusBar sharedView]];

    if(!self.superview)
        [self.overlayWindow addSubview:self];

    [self.overlayWindow setHidden:NO];
    [self.topBar setHidden:NO];
    //[self.activityIndicator setHidden:withActivityIndicator];
    
    self.topBar.backgroundColor = barColor;
    NSString *labelText = status;
    CGRect labelRect = CGRectZero;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    
    if(labelText) {
    
        CGSize stringSize = [labelText sizeWithFont:self.stringLabel.font
                                  constrainedToSize:CGSizeMake(self.topBar.frame.size.width, self.topBar.frame.size.height)];
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        
        labelRect = CGRectMake((self.topBar.frame.size.width / 2) - (stringWidth / 2), 0, stringWidth, stringHeight);
    }
    self.stringLabel.frame = labelRect;
    self.stringLabel.alpha = 0.0;
    self.stringLabel.hidden = NO;
    self.stringLabel.text = labelText;
    self.stringLabel.textColor = textColor;
    
    if (withActivityIndicator) {
    
        self.activityIndicator.center = CGPointMake(self.stringLabel.frame.origin.x - 15, self.stringLabel.center.y);
        self.activityIndicator.alpha = 0.0;
        [self.activityIndicator startAnimating];
    }
    else {
 
        if (activityIndicator != nil) {
            [self.activityIndicator stopAnimating];
        }
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.stringLabel.alpha = 1.0;
        
        if (withActivityIndicator) {
            
            self.activityIndicator.alpha = 1.0;
        }
    }];
    
    [self setNeedsDisplay];
}

-(void) dismissEnd {
    
    [topBar removeFromSuperview];
    topBar = nil;
    
    [overlayWindow removeFromSuperview];
    overlayWindow = nil;
    
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
}

- (void) dismiss:(NSString *)status
{
    if (status==nil || [status isEqualToString:stringLabel.text] ) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.stringLabel.alpha = 0.0;
            
            if (activityIndicator)
                activityIndicator.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self dismissEnd];
        }];
    }
    else {
        
        NSLog (@"Pas de dismiss de %@ car status en cours = %@", status, stringLabel.text);
    }
    
}

- (UIWindow *)overlayWindow {
    
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
        overlayWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return overlayWindow;
}

- (UIView *)topBar {
    
    if(!topBar) {
    
        topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, overlayWindow.frame.size.width, kHeightStatusBar)];
        [overlayWindow addSubview:topBar];
    }
    
    return topBar;
}

- (UIActivityIndicatorView *)activityIndicator {
  
    if (!activityIndicator) {
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
     
        activityIndicator.transform = CGAffineTransformMakeScale (0.7, 0.7);

        [overlayWindow addSubview:activityIndicator];
    }
    
    return activityIndicator;
}

- (UILabel *)stringLabel {
    
    if (stringLabel == nil) {
        
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        stringLabel.textAlignment = UITextAlignmentCenter;
#else
        stringLabel.textAlignment = NSTextAlignmentCenter;
#endif
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:14.0];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview)
        [self.topBar addSubview:stringLabel];
    
    return stringLabel;
}

@end
