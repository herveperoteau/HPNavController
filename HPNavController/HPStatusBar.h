//
//  HPStatusBar.h
//
//

#define kHeightStatusBar 20.0f

@interface HPStatusBar : UIView

//+ (void)showWithStatus:(NSString*)status;
//+ (void)showWithStatus:(NSString*)status withActivityIndicator:(BOOL)withActivityIndicator;
//+ (void)showErrorWithStatus:(NSString*)status;
//+ (void)showSuccessWithStatus:(NSString*)status;

+ (void)showWithStatus:(NSString*)status fromViewController:(UIViewController *)viewController;
+ (void)showWithStatus:(NSString*)status withActivityIndicator:(BOOL)withActivityIndicator  fromViewController:(UIViewController *)viewController;
+ (void)showErrorWithStatus:(NSString*)status fromViewController:(UIViewController *)viewController;
+ (void)showSuccessWithStatus:(NSString*)status fromViewController:(UIViewController *)viewController;

+ (void)dismiss;
+ (void)dismiss:(NSString *)status;


@end
