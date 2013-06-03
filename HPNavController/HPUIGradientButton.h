//
//  HPUIGradientButton.h
//
//  Based on NVUIGradientButton
//
typedef NS_ENUM(NSUInteger, HPUIGradientButtonStyle)
{
	HPUIGradientButtonStyleDefault = 1,
	HPUIGradientButtonStyleBlackOpaque,
	HPUIGradientButtonStyleBlackTranslucent
};

typedef NS_ENUM(NSUInteger, HPUIGradientButtonRadiusStyle)
{
	HPUIGradientButtonRadiusStyleAll,
	HPUIGradientButtonRadiusStyleLeft,
	HPUIGradientButtonRadiusStyleRight,
};

@interface HPUIGradientButton : UIControl

@property (nonatomic, assign) HPUIGradientButtonStyle style;

@property (nonatomic) CGFloat cornerRadius; // Default to 10.0
@property (nonatomic, assign) HPUIGradientButtonRadiusStyle styleRadius;

@property (nonatomic) CGFloat borderWidth; // Default to 2.0
@property (strong, nonatomic) UIColor *tintColor; // Default to gray
@property (strong, nonatomic) UIColor *highlightedTintColor; // Default to nice blue
@property (strong, nonatomic) UIColor *borderColor; // Default to darkGray
@property (strong, nonatomic) UIColor *highlightedBorderColor; // Default to white
@property (strong, nonatomic) UIColor *textColor; // Default to black
@property (strong, nonatomic) UIColor *highlightedTextColor; // Default to white
@property (strong, nonatomic) UIColor *textShadowColor; // Default to clear
@property (strong, nonatomic) UIColor *highlightedTextShadowColor; // Default to darkGrey
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *highlightedText; // Default to text
@property (copy, nonatomic) NSString *disabledText; // Default to text
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, getter = isGradientEnabled) BOOL gradientEnabled; // Default to YES, set to NO to draw flat color
@property (nonatomic, strong) UIImage *rightAccessoryImage;
@property (nonatomic, strong) UIImage *rightHighlightedAccessoryImage;
@property (nonatomic, strong) UIImage *leftAccessoryImage;
@property (nonatomic, strong) UIImage *leftHighlightedAccessoryImage;

// Designated initializer
- (id)initWithFrame:(CGRect)frame style:(HPUIGradientButtonStyle)style cornerRadius:(CGFloat)cornerRadius radiusStyle:(HPUIGradientButtonRadiusStyle) radiusStyle borderWidth:(CGFloat)borderWidth andText:(NSString *)text;

// Convenient initializers
- (id)initWithFrame:(CGRect)frame style:(HPUIGradientButtonStyle)style cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth andText:(NSString *)text;
- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth andText:(NSString *)text;
- (id)initWithFrame:(CGRect)frame style:(HPUIGradientButtonStyle)style;

// Convenience for configuration depending on states
- (void)setTintColor:(UIColor *)tintColor forState:(UIControlState)state;
- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state;
- (void)setTextColor:(UIColor *)textColor forState:(UIControlState)state;
- (void)setTextShadowColor:(UIColor *)textShadowColor forState:(UIControlState)state;
- (void)setText:(NSString *)text forState:(UIControlState)state;
- (void)setRightAccessoryImage:(UIImage *)rightAccessoryImage forState:(UIControlState)state;
- (void)setLeftAccessoryImage:(UIImage *)leftAccessoryImage forState:(UIControlState)state;

@end
