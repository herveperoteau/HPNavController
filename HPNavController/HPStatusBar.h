//
//  HPStatusBar.h
//
//

#define kHeightStatusBar 20.0f

@interface HPStatusBar : UIView

+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status withActivityIndicator:(BOOL)withActivityIndicator;
+ (void)showErrorWithStatus:(NSString*)status;
+ (void)showSuccessWithStatus:(NSString*)status;

+ (void)dismiss;
+ (void)dismiss:(NSString *)status;


@end
