//
//  HPNavController.m
//  MyTestHPStackNavController
//
//  Created by Hervé PEROTEAU on 12/03/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

/**

 Algo direct acces menu :
 
 btnAccesMenu :
    popViewControllerAnimated withHierarchy 
        => visiblePartialOverMenuView=YES pour le top de la hierarchy
        => cache le reste de la hierarchy en dehors de l'ecran pour voir le menu

 Quand on fait glisser la top view vers la gauche pour recouvir le menu :
        => a la fin du push, remettre en position la hierarchy qu'on avait deplacée au moment du btnAccesMenu
 
 Quand on clique sur un item du menu :
 
    - (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
        if (top && top.hpNavItem.visiblePartialOverMenuView && top != viewController) {

        => il faut virer le top, mais en + il faut virer aussi toute l'ancienne hierarchy !!!

 */


#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "HPNavController.h"
#import "UIViewController+HPNavController_protected.h"
#import "UIViewController+HPNavController.h"
#import "HPNavItem.h"
#import "HPUIGradientButton.h"
#import "HPStatusBar.h"
#import "HPDeviceVersion.h"
#import "HPNavStyle.h"


#define kNavBarHeight 44
#define kAnimationDuration 0.35
#define kReduceBelow 0.9
#define kPanGesturePercentageToInducePop 0.3
#define kPanGesturePercentageToInducePush 0.6


@interface HPNavController () <UIGestureRecognizerDelegate>

    @property(nonatomic, readwrite, strong) UIViewController *focusedViewController;
    @property(nonatomic, readwrite, strong) UIViewController *menuViewController;
    @property(nonatomic, strong) UIImage *iconBtnMenu;
    @property(nonatomic, strong) UIImage *iconBtnMenuSelected;
    @property(nonatomic, assign) BOOL flagPermanentDirectAccesMenu;

@end

@implementation HPNavController {
    
    BOOL flagPopBeforePush;
    BOOL flagDuringInit;
}

#pragma mark methodes principales (init, push, pop)

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
    
        [self pushViewController:rootViewController animated:NO];
    }
    
    return self;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIViewController *top = self.topViewController;
    
    if (top && top.hpNavItem.visiblePartialOverMenuView && top != viewController) {
        
        //NSLog(@"pushViewController %@ Dabord on vire l'ancien %@ ", viewController.class, top.class);

        // On va virer la hierarchy cachée (suite a un accesdirectMenu)
        [self removeHierarchyHide];
        
        // Ensuite on vire l'ancien rootViewController
        top.hpNavItem.visiblePartialOverMenuView = NO;
        
        flagPopBeforePush = YES;
        
        [self popViewControllerAnimated:YES completion:^{

            flagPopBeforePush = NO;
            
            //NSLog(@"After popEnded, pushViewController %@ ", viewController.class);
            
            [self pushPrepare:viewController animated:animated];
            
            [self pushRun:viewController animated:animated completion:^{
                
                [self pushEnded:viewController animated:animated];
            }];
        }];
        
        return;
    }

    //NSLog(@"pushViewController %@ ", viewController.class);
    
    [self pushPrepare:viewController animated:animated];
    
    [self pushRun:viewController animated:animated completion:^{
    
        [self pushEnded:viewController animated:animated];
    }];
}

-(BOOL) isChildLayoutVisible:(UIViewController *)child {
    
    CGFloat centerx = child.hpNavItem.containerView.center.x;
    
    if (centerx < self.view.bounds.size.width) {
        
       // NSLog(@"isChildLayoutVisible(%@) => YES car centerx=%f", [child class], centerx);
        return YES;
    }
    
   // NSLog(@"isChildLayoutVisible(%@) => NO car centerx=%f", [child class], centerx);
    return NO;
}

-(void) layoutHierarchyHide:(BOOL) flagHide {
    
    //NSLog(@">> layoutHierarchyHide flagHide=%d", flagHide);
    
    UIViewController *top = self.topViewController;
    
    NSArray *childs = self.viewControllers;
    
    for (UIViewController *child in childs) {
        
        if (child != top && child != self.menuViewController) {
            
            if (flagHide) {
                
                if ([self isChildLayoutVisible:child]) {
                
                   // NSLog(@"set LAYOUT HIDE %@ (title=%@)", [child class], child.hpNavItem.title);
            
                    CGPoint center = child.hpNavItem.containerView.center;
                    center.x = 2*self.view.bounds.size.width;
                    child.hpNavItem.containerView.center = center;
                }
            }
            else {
                
                if (![self isChildLayoutVisible:child]) {
                
                    //NSLog(@"set LAYOUT VISIBLE %@ (title=%@)", [child class], child.hpNavItem.title);
                
                    CGPoint center = child.hpNavItem.containerView.center;
                    center.x = self.view.bounds.size.width / 2;
                    child.hpNavItem.containerView.center = center;
                }
            }
        }
    }
}

-(void) removeHierarchyHide {
    
   // NSLog(@"removeHierarchyHide ...");
    
    UIViewController *top = self.topViewController;
    
    NSArray *childs = self.viewControllers;
    
    for (UIViewController *child in childs) {

       // NSLog(@"removeHierarchyHide child=%@", [child class]);

        if (child != top && child != self.menuViewController) {
            
            if (![self isChildLayoutVisible:child]) {
                    
                NSLog(@"remove LAYOUT HIDE %@ (title=%@)", [child class], child.hpNavItem.title);
                [self removeFromParent:child];
            }
            else {
                
               // NSLog(@"NOT remove LAYOUT HIDE %@ (title=%@) car Visible ???", [child class], child.hpNavItem.title);
            }
        }
        else {
            
            if (child == top) {
               
               // NSLog(@"removeHierarchyHide child=%@ NOT BECAUSE IS TOP", [child class]);
            }
            else if (child == self.menuViewController) {
                
               // NSLog(@"removeHierarchyHide child=%@ NOT BECAUSE IS MENU", [child class]);
            }
        }
    }
}


- (UIViewController *)popViewControllerAndHierarchyAnimated:(BOOL)animated {
    
    [self layoutHierarchyHide:YES];
    
    return [self popViewControllerAnimated:animated completion:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {

    return [self popViewControllerAnimated:animated completion:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completionAfterPopEnded {
    
    UIViewController *pop = self.topViewController;
    
    [self popPrepare:pop animated:animated];
    
    [self popRun:pop animated:animated completion:^{
        
        [self popEnded:pop animated:animated completion:completionAfterPopEnded];
    }];
    
    return pop;
}


#pragma mark - Public access methods

- (NSArray *)viewControllers {
    
    return [self.childViewControllers copy];
}

- (UIViewController *)topViewController {
    
    return [self.childViewControllers lastObject];
}

#pragma mark - View controller hierarchy methods

- (void)addViewControllerToHierarchy:(UIViewController *)viewController {
    
    [self addChildViewController:viewController];
    [viewController setHPNavController:self];
}

- (UIViewController *)ancestorViewControllerTo:(UIViewController *)viewController {
    
    NSUInteger index = [self.childViewControllers indexOfObject:viewController];
    
    for (int i=index-1; i>=0; i--) {
        
        UIViewController *vc = self.childViewControllers[i];
        
        if ([self isChildLayoutVisible:vc]) {
            
            return vc;
        }
    }
    
    return (index > 0)? self.childViewControllers[index - 1] : nil;
}

-(void) pushPrepare:(UIViewController *)viewController animated:(BOOL) animated {
    
    //NSLog(@">>> pushPrepare %@", viewController.class);
        
    self.focusedViewController = viewController;

    UIViewController *top = self.topViewController;
        
    if (top != nil /*&& top != self.menuViewController*/) {
        
        // insert Mask Gradient on previous TopView
        [top.hpNavItem addMaskView];
    }
    
    // Fire the 'willAppear/Disappear' methods
    if (top != nil) {
        
        if (viewController.hpNavItem.visiblePartialOverMenuView) {
            
            //NSLog(@"--> pushPrepare %@ => beginAppareance=NO pour %@", viewController.class, self.menuViewController);
            if (!flagDuringInit) {
                [self.menuViewController beginAppearanceTransition:NO
                                                          animated:animated];
            }
        }
        else {
            
            //NSLog(@"--> pushPrepare %@ => beginAppareance=NO pour %@", viewController.class, top.class);
            if (!flagDuringInit) {
                
                [top beginAppearanceTransition:NO
                                      animated:animated];
            }
        }
    }

    if (viewController.hpNavItem.visiblePartialOverMenuView) {
        
        //NSLog(@"<<< pushPrepare %@ (visiblePartialOverMenuView)", viewController.class);

        return;
    }
    
    // add ViewController in child
    [self addViewControllerToHierarchy:viewController];

    if (!flagDuringInit) {
        
        //NSLog(@"--> pushPrepare %@  => beginAppareance=YES", viewController.class);
        
        [viewController beginAppearanceTransition:YES
                                         animated:animated];
    }

    // Encapsulation dans un ContainerView (NavBar+Content)
    [self ensureContainerViewExistsForController:viewController];

    
    // Positionne le ContainerView a droite l'ecran
    CGRect rect = self.view.bounds;
    rect.origin.x = self.view.bounds.size.width;
    viewController.hpNavItem.containerView.frame = rect;
    
    // Insert View in NavController
    [self.view addSubview:viewController.hpNavItem.containerView];
    
    //NSLog(@"<<< pushPrepare %@", viewController.class);

    
}

- (void)ensureContainerViewExistsForController:(UIViewController *)viewController {
    
    if ( !viewController.hpNavItem.containerView ) {
        
        [viewController.hpNavItem setContainerView:[[UIView alloc] initWithFrame:self.view.bounds]];
        
        CGRect navBarFrame, contentFrame;
        UINavigationBar *navBar = nil;
        
        if (viewController == self.menuViewController) {
 
            viewController.hpNavItem.containerView.backgroundColor = viewController.view.backgroundColor;
            // pas de navbar sur le Menu

            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                
                contentFrame = viewController.hpNavItem.containerView.bounds;
            }
            else {
           
                // iOS7 StatusBar inclus
                contentFrame = CGRectMake(viewController.hpNavItem.containerView.bounds.origin.x,
                                          kHeightStatusBar,
                                          viewController.hpNavItem.containerView.bounds.size.width,
                                          viewController.hpNavItem.containerView.bounds.size.height-kHeightStatusBar);
            }
        }
        else {
        
            // Divise le containerView en 2 parties : la navBar et le contentView
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {

                CGRectDivide(viewController.hpNavItem.containerView.bounds, &navBarFrame, &contentFrame, kNavBarHeight, CGRectMinYEdge);
            }
            else {

                // iOS7 StatusBar inclus
                CGRect bounds = CGRectMake(viewController.hpNavItem.containerView.bounds.origin.x,
                                           kHeightStatusBar,
                                           viewController.hpNavItem.containerView.bounds.size.width,
                                           viewController.hpNavItem.containerView.bounds.size.height-kHeightStatusBar);
            
                CGRectDivide(bounds, &navBarFrame, &contentFrame, kNavBarHeight, CGRectMinYEdge);
            }
            
            navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
            navBar.delegate = self;  // pour gerer l'appui sur le BackButton
        }
        
        UIViewController *previousViewController = [self ancestorViewControllerTo:viewController];
        
        if (previousViewController.navigationItem) {
            
            //NSLog(@"previousViewController.navigationItem.title=%@", previousViewController.navigationItem.title);
            
            UINavigationItem *previousItem = [[UINavigationItem alloc] initWithTitle:previousViewController.navigationItem.title];
            previousItem.backBarButtonItem = previousViewController.navigationItem.backBarButtonItem;
            previousItem.leftBarButtonItem = previousViewController.navigationItem.leftBarButtonItem;
            
            // pour avoir le button back
            if (navBar)
                [navBar pushNavigationItem:previousItem animated:NO];
        }
        
        // Add btnAccesMenu
        if (self.flagPermanentDirectAccesMenu && viewController != self.menuViewController) {
            
           // NSLog(@"check leftBarButtonItem %@ ...", viewController.navigationItem.leftBarButtonItem);
            
            if (viewController.navigationItem.leftBarButtonItem == nil) {
                
                NSLog(@"create btn acces direct menu pour %@", [viewController class]);
                
                HPUIGradientButton *gradientButton = [[HPUIGradientButton alloc] initWithFrame:CGRectMake(0, 0, 37, 31)
                                                                                         style:HPUIGradientButtonStyleDefault
                                                                                  cornerRadius:6.0
                                                                                   radiusStyle:HPUIGradientButtonRadiusStyleAll
                                                                                   borderWidth:2.0
                                                                                       andText:nil];
                
                [gradientButton addTarget:self
                                   action:@selector(accesDirectMenu:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                if (self.iconBtnMenu != nil) {
                    
                    gradientButton.leftAccessoryImage = self.iconBtnMenu;
                    gradientButton.leftHighlightedAccessoryImage = self.iconBtnMenuSelected;
                    gradientButton.text = nil;
                    gradientButton.highlightedText = nil;
                }
                
                /*
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 31)];
                [btn addTarget:self
                                   action:@selector(accesDirectMenu:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                [btn setImage:[UIImage imageNamed:@"menu-icon"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"menu-icon-selected"] forState:UIControlStateHighlighted];
                
                UIBarButtonItem *btnMenu = [[UIBarButtonItem alloc] initWithCustomView:btn];
                 */
                
                UIBarButtonItem *btnMenu = [[UIBarButtonItem alloc] initWithCustomView:gradientButton];
                viewController.navigationItem.leftBarButtonItem = btnMenu;
            }
        }
        
        // Fait fonctionner le NavItem systeme, pour avoir les backs button, et title a jour ...
        if (navBar)
            [navBar pushNavigationItem:viewController.navigationItem animated:NO];
        
        // Add NavBar in ContainerView
        if (navBar)
            [viewController.hpNavItem.containerView addSubview:navBar];
        
        // Add ContentView in ContainerView
        viewController.view.frame = contentFrame;
        [viewController.hpNavItem.containerView addSubview:viewController.view];
        
        // coins arrondis
        [HPNavStyle setRoundGrayBorder:viewController.hpNavItem.containerView];
    }
}


-(void) pushEndTransitionLayout:(UIViewController *) viewController {
   
    UIViewController *previousViewController = [self ancestorViewControllerTo:viewController];

    if (previousViewController /*&& previousViewController!=self.menuViewController*/) {
        
        [previousViewController.hpNavItem setOpacityMaskView:1.0f];
        previousViewController.hpNavItem.containerView.transform = CGAffineTransformMakeScale (kReduceBelow, kReduceBelow);
    }
    
    // Positionne le ContainerView en plein ecran
    CGRect rect = self.view.bounds;
    
    //NSLog(@"pushEndTransitionLayout rect view.bounds= (%f, %f) (%f x %f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    rect.origin.x = 0;
    viewController.hpNavItem.containerView.frame = rect;
        
}

-(void) pushRun:(UIViewController *)viewController animated:(BOOL) animated completion:(void (^)())completion {
  
    if (animated && self.view.window) {
        
        UIViewController *previousViewController = [self ancestorViewControllerTo:viewController];
        
        if (previousViewController && previousViewController!=self.menuViewController) {
            
           // [previousViewController.hpNavItem setOpacityMaskView:0.0f];
        }
            
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            [self pushEndTransitionLayout:viewController];
            
        } completion:^(BOOL finished) {
            
            completion();
        }];
    }
    else {
        
        [self pushEndTransitionLayout:viewController];
        
        completion();
    }
}

-(void) pushEnded:(UIViewController *)viewController animated:(BOOL) animated {
 
    //NSLog(@">>>pushEnded pour %@", viewController.class);
    
    UIViewController *previousViewController = [self ancestorViewControllerTo:viewController];
    
    if (!viewController.hpNavItem.visiblePartialOverMenuView) {
        
        [viewController didMoveToParentViewController:self];
        
        if (!flagDuringInit) {
        
            //NSLog(@"<-- pushEnded pour %@ => endAppearenceTransition pour %@", viewController.class, viewController.class);
            [viewController endAppearanceTransition];
        }
    }
    
    viewController.hpNavItem.containerView.userInteractionEnabled = YES;
    [self subviewsUserInteraction:viewController enabled:YES];
    
    if (previousViewController) {
        
        if (!flagDuringInit) {
            
            //NSLog(@"<-- pushEnded pour %@ => endAppearenceTransition pour previous %@", viewController.class, previousViewController.class);
            [previousViewController endAppearanceTransition];
        }
        
        previousViewController.hpNavItem.containerView.userInteractionEnabled = NO;
        [self subviewsUserInteraction:previousViewController enabled:NO];
    }

    viewController.hpNavItem.title = viewController.title; // sert au debug uniquement
    
    if (self.menuViewController && viewController!=self.menuViewController) {
        
        //self.menuViewController.hpNavItem.containerView.hidden = YES;
        viewController.hpNavItem.visiblePartialOverMenuView = NO;
    }
    
    // Add gesture Pan
    if (previousViewController) {
        
        [viewController.hpNavItem removeMaskView];  // pour la rendre a nouveau "touchable"
        [viewController.hpNavItem.containerView removeAllGestureRecognizer];
    
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(viewDidPan:)];
        gestureRecognizer.delegate = self;
        [viewController.hpNavItem.containerView addGestureRecognizer:gestureRecognizer];
    }
    
    // on va repositionner la hierarchy qu'on aurait pu cacher sur un acces direct au menu
    [self layoutHierarchyHide:NO];

    if (flagDuringInit && viewController != self.menuViewController) {

        flagDuringInit = NO;
    
       // NSLog (@"init fin");
    
        // Pas necessaire pendant l'init car sera appeler quand meme
        // quand on fait [self.window makeKeyAndVisible] au lancement de l'application

//        [viewController beginAppearanceTransition:YES
//                                             animated:NO];
//    
//        [viewController endAppearanceTransition];
    }
        
    //NSLog(@"<<< pushEnded pour %@", viewController.class);
}

-(void) subviewsUserInteraction:(UIViewController *) viewController enabled:(BOOL)enabled{

    //NSLog(@"subviewsUserInteraction %@ enabled=%d", [viewController class], enabled);
        
    for (UIView *view in viewController.hpNavItem.containerView.subviews) {
        view.userInteractionEnabled = enabled;
    }
}


-(void) popPrepare:(UIViewController *)viewController animated:(BOOL) animated  {
    
    //NSLog(@">>> popPrepare %@", viewController.class);
    
    UIViewController *previousViewController = [self ancestorViewControllerTo:viewController];
    
    self.focusedViewController = previousViewController;

    if (previousViewController == self.menuViewController && !flagPopBeforePush) {
        
        self.menuViewController.hpNavItem.containerView.userInteractionEnabled=NO;  // Pour etre sure que l'animation soit terminé avant d'autoriser le touch
        //self.menuViewController.hpNavItem.containerView.hidden = NO;
        
    }

    // Fire the 'willAppear/Disappear' methods
    //NSLog(@"--> popPrepare %@ -> beginAppearance=YES pour %@", viewController.class, previousViewController.class);
    
    if (!flagPopBeforePush && !flagDuringInit) {
    
        [previousViewController beginAppearanceTransition:YES
                                                 animated:animated];
    }
    
    if (!viewController.hpNavItem.visiblePartialOverMenuView) {
        
        if (!flagDuringInit) {
        //NSLog(@"--> popPrepare %@ -> beginAppearance=NO pour %@", viewController.class, viewController.class);
            
            // fait par le remove
//            [viewController beginAppearanceTransition:NO
//                                             animated:animated];
        }
    }
    
    //NSLog(@"<<< popPrepare %@", viewController.class);

}

-(void) popEndTransitionLayout:(UIViewController *) viewController {
    
    UIViewController *previousViewController = [self ancestorViewControllerTo:viewController];
    
    if (previousViewController && !flagPopBeforePush) {
        
        // repositionne la page en dessous en plein ecran, sans le mask
        [previousViewController.hpNavItem setOpacityMaskView:0.0f];
        previousViewController.hpNavItem.containerView.transform = CGAffineTransformIdentity;
    }
    
    // Positionne le ContainerView a droite l'ecran
    
    CGRect rect = self.view.bounds;
    
    if (viewController.hpNavItem.visiblePartialOverMenuView) {
        
        rect.origin.x = self.view.bounds.size.width - kVisiblePartOfRootWhenDisplayMenu;
    }
    else {
        
        rect.origin.x = self.view.bounds.size.width;
    }
    
    viewController.hpNavItem.containerView.frame = rect;
}

-(void) popRun:(UIViewController *)viewController animated:(BOOL) animated completion:(void (^)())completion {
 
    if (animated && self.view.window) {
        
        NSTimeInterval duration = kAnimationDuration;
        
        if (viewController.hpNavItem.containerView.frame.origin.x > 0) {
            
            duration = kAnimationDuration / 2;
        }
                
        [UIView animateWithDuration:duration animations:^{
            
            [self popEndTransitionLayout:viewController];
            
        } completion:^(BOOL finished) {
            
            completion();
        }];
    }
    else {
        
        [self popEndTransitionLayout:viewController];
        
        completion();
    }
}

-(void) removeFromParent:(UIViewController *)viewController {

    // inverse du didMoveToParentViewController fait au moment du push
    [viewController willMoveToParentViewController:nil];

    [viewController.hpNavItem.containerView removeFromSuperview];
    [viewController removeHPNavController];

    // Enleve le controller des childs du NavController
    [viewController removeFromParentViewController];
}

-(void) popEnded:(UIViewController *)viewController animated:(BOOL) animated  completion:(void (^)())completion {
    
    //NSLog(@">>> popEnded %@", viewController.class);
    
    UIViewController *previousViewController = [self ancestorViewControllerTo:viewController];
    
    if (!viewController.hpNavItem.visiblePartialOverMenuView) {

        if (!flagDuringInit) {
            
            //NSLog(@"<-- popEnded %@ : endAppearance pour %@", viewController.class, viewController.class);
            
            // Fait par le remove
            //[viewController endAppearanceTransition];
        }
        
        viewController.hpNavItem.containerView.userInteractionEnabled = NO;
    }
    
    [self subviewsUserInteraction:viewController enabled:NO];
    
    if (previousViewController && !flagPopBeforePush) {
    
        if (!flagDuringInit) {
            
            //NSLog(@"<-- popEnded %@ : endAppearance pour %@", viewController.class, previousViewController.class);
            [previousViewController endAppearanceTransition];
        }
        
        previousViewController.hpNavItem.containerView.userInteractionEnabled = YES;
        [self subviewsUserInteraction:previousViewController enabled:YES];

//        if (previousViewController == self.menuViewController) {
//            
//            //NSLog(@"popEnded %@ : remet le menu avec userInteractionEnabled=YES", viewController.class);
//            previousViewController.hpNavItem.containerView.userInteractionEnabled = YES;
//            [self subviewsUserInteraction:previousViewController enabled:YES];
//        }
    }
    
    if (viewController.hpNavItem.visiblePartialOverMenuView) {

        [viewController.hpNavItem.containerView removeAllGestureRecognizer];
        
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(viewDidPanWhenMenuDisplayed:)];
        gestureRecognizer.delegate = self;
        [viewController.hpNavItem.containerView addGestureRecognizer:gestureRecognizer];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(viewDidTapWhenMenuDisplayed:)];
        
        [viewController.hpNavItem.containerView addGestureRecognizer:tapGestureRecognizer];
        
        // elle est encore visible, donc on la garde dans la hierarchie
        [viewController.hpNavItem addMaskView]; // pour la rendre non active
        [viewController.hpNavItem setOpacityMaskView:0.1f];
        
        //NSLog(@"<<< popEnded %@ (visiblePartialOverMenuView)", viewController.class);

        if (completion)
            completion();
        
        return;
    }
    
    // Enleve le GradientMask qui etait dessus la view
    if (!flagPopBeforePush) {

        [previousViewController.hpNavItem removeMaskView];
    }
    
    [self removeFromParent:viewController];
        
    //NSLog(@"<<< popEnded %@", viewController.class);
    
    if (completion)
        completion();
}


#pragma mark - Delegate methods

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    //NSLog(@"shouldPopItem ...");
    
    UIViewController *pop = self.topViewController;

    UIViewController *previousViewController = [self ancestorViewControllerTo:pop];
    
    if (self.menuViewController!= nil && previousViewController == self.menuViewController) {
        
        pop.hpNavItem.visiblePartialOverMenuView = YES;
    }
    
    [self popViewControllerAnimated:YES];
    return NO;
}


#pragma mark - Gesture

-(void) viewDidTapWhenMenuDisplayed:(id) sender {
    
    UITapGestureRecognizer *gestureRecognizer = sender;
    
    UIViewController *pannedViewController = self.childViewControllers[[self.childViewControllers indexOfObjectPassingTest:^BOOL(UIViewController *cur, NSUInteger idx, BOOL *stop) {
        return (cur.hpNavItem.containerView == [sender view]);
    }]];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        //NSLog(@"viewDidTapWhenMenuDisplayed : began gesture ");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
        //NSLog(@"viewDidTapWhenMenuDisplayed : end gesture ");
        [self pushViewController:pannedViewController animated:YES];
    }
    
}


-(void) viewDidPanWhenMenuDisplayed:(id)sender {
    
    UIPanGestureRecognizer *gestureRecognizer = sender;
    
    UIViewController *pannedViewController = self.childViewControllers[[self.childViewControllers indexOfObjectPassingTest:^BOOL(UIViewController *cur, NSUInteger idx, BOOL *stop) {
        return (cur.hpNavItem.containerView == [sender view]);
    }]];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        //NSLog(@"viewDidPanWhenMenuDisplayed : began gesture ");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        //NSLog(@"viewDidPanWhenMenuDisplayed : fin de gesture ");
        
        CGRect finalFrame = pannedViewController.hpNavItem.containerView.frame;
        
        if (finalFrame.origin.x <= [sender view].frame.size.width * kPanGesturePercentageToInducePush) {
            
            // Valide le push
            [self pushViewController:pannedViewController animated:YES];
        }
        else {
            
            // Retour a droite (partiellement visible)
            [UIView animateWithDuration:0.3
                             animations:^{

                                 [self popEndTransitionLayout:pannedViewController];
                             }
                             completion:^(BOOL finished) {
                             }
             ];
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGRect finalFrame = pannedViewController.hpNavItem.containerView.frame;
        
        finalFrame.origin.x = (self.view.bounds.size.width - kVisiblePartOfRootWhenDisplayMenu) +
                            [gestureRecognizer translationInView:self.view].x;
        
        //NSLog(@"viewDidPanWhenMenuDisplayed : gesture en cours x=%f", finalFrame.origin.x);
        
        if (finalFrame.origin.x >= 0) {
            
            if (finalFrame.origin.x > self.view.bounds.size.width - kVisiblePartOfRootWhenDisplayMenu) {
                
               // NSLog(@"viewDidPanWhenMenuDisplayed : On a atteint x max = %f", finalFrame.origin.x);
                
                return;
            }
            
            [UIView animateWithDuration:0.1 animations:^{
                
                //if (previousViewController != self.menuViewController) {
                
                // reduce/augmente la view en dessous
                CGFloat a = (1 - kReduceBelow ) / self.view.bounds.size.width;
                CGFloat reduceBelow = (a * finalFrame.origin.x) + kReduceBelow;
                //NSLog(@"reduceBelow=%f", reduceBelow);
                
                self.menuViewController.hpNavItem.containerView.transform = CGAffineTransformMakeScale (reduceBelow, reduceBelow);
                
                // reduce/augmente opacity de la view en dessous
                //   opacity = a X + b
                //   Si x=0 alors opacity=1.0 => b=1.0
                //   Si x=W alors opacity=0.0 = aW + 1 => a = (-1)/W
                a = -1 / self.view.bounds.size.width;
                CGFloat opacity = (a * finalFrame.origin.x) + 1.0;
                //NSLog(@"opacity=%f", opacity);
                
                [self.menuViewController.hpNavItem setOpacityMaskView:opacity];
                
                
                pannedViewController.hpNavItem.containerView.frame = finalFrame;
            }];
        }
    }
    
}


- (void)viewDidPan:(id)sender {
    
    UIPanGestureRecognizer *gestureRecognizer = sender;
    
    UIViewController *pannedViewController = self.childViewControllers[[self.childViewControllers indexOfObjectPassingTest:^BOOL(UIViewController *cur, NSUInteger idx, BOOL *stop) {
        return (cur.hpNavItem.containerView == [sender view]);
    }]];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        //NSLog(@"viewDidPan : began gesture ");
        
        UIViewController *previousViewController = [self ancestorViewControllerTo:pannedViewController];
        
        if (self.menuViewController != nil && previousViewController == self.menuViewController) {
            
            //self.menuViewController.hpNavItem.containerView.hidden = NO;
            pannedViewController.hpNavItem.visiblePartialOverMenuView = YES;
        }
    }
    
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        //NSLog(@"viewDidPan : fin de gesture ");
        
        if ([gestureRecognizer translationInView:self.view].x >= [sender view].frame.size.width * kPanGesturePercentageToInducePop) {
            
            // Termine le pop
            [self popViewControllerAnimated:YES];
        }
        else {
            
            // Retour a gauche (plein ecran)
            CGRect finalFrame = pannedViewController.hpNavItem.containerView.frame;
            finalFrame.origin.x = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 
                                 pannedViewController.hpNavItem.containerView.frame = finalFrame;
                
                             }
                             completion:^(BOOL finished) {
                                 
                                 if (self.menuViewController) {
                                     //self.menuViewController.hpNavItem.containerView.hidden = YES;
                                     pannedViewController.hpNavItem.visiblePartialOverMenuView = NO;
                                 }
                             }
             ];
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGRect finalFrame = pannedViewController.hpNavItem.containerView.frame;
        
        finalFrame.origin.x = [gestureRecognizer translationInView:self.view].x;
        
        //NSLog(@"viewDidPan : gesture en cours x=%f", finalFrame.origin.x);
        
        if (finalFrame.origin.x >= 0) {
            
            if (pannedViewController.hpNavItem.visiblePartialOverMenuView &&
                finalFrame.origin.x > self.view.bounds.size.width - kVisiblePartOfRootWhenDisplayMenu) {
                
                //NSLog(@"viewDidPan : On a atteint x max = %f", finalFrame.origin.x);
                
                return;
            }
        
            [UIView animateWithDuration:0.1 animations:^{
            
                //   scaleMask = a X + b
                //   Si x=0 alors scaleMask=0.9 (kReduceBelow) => b=0.9 
                //   Si x=W alors scaleMask=1 1 = aW + 0.9 => a = (1-0.9)/W
                //
                UIViewController *previousViewController = [self ancestorViewControllerTo:pannedViewController];
                
                //if (previousViewController != self.menuViewController) {
                    
                    // reduce/augmente la view en dessous
                    CGFloat a = (1 - kReduceBelow ) / self.view.bounds.size.width;
                    CGFloat reduceBelow = (a * finalFrame.origin.x) + kReduceBelow;
                    //NSLog(@"reduceBelow=%f", reduceBelow);
                    
                    previousViewController.hpNavItem.containerView.transform = CGAffineTransformMakeScale (reduceBelow, reduceBelow);
                    
                    // reduce/augmente opacity de la view en dessous
                    //   opacity = a X + b
                    //   Si x=0 alors opacity=1.0 => b=1.0
                    //   Si x=W alors opacity=0.0 = aW + 1 => a = (-1)/W
                    a = -1 / self.view.bounds.size.width;
                    CGFloat opacity = (a * finalFrame.origin.x) + 1.0;
                    //NSLog(@"opacity=%f", opacity);
                    
                    [previousViewController.hpNavItem setOpacityMaskView:opacity];
                /*}
                else {
                    
                    self.menuViewController.hpNavItem.containerView.hidden = NO;
                }
                */
                
                pannedViewController.hpNavItem.containerView.frame = finalFrame;
                
            }];
        }
    }
}

#pragma mark - Specifique Menu

-(void) configureMenuViewController:(UIViewController *) menu {
  
    NSAssert(self.menuViewController==nil, @"Menu already exist ???");
    
    self.menuViewController = menu;
    
    [self pushViewController:self.menuViewController animated:NO];
    

}

-(id) initWithRootViewController:(UIViewController *) rootViewController
           andMenuViewController:(UIViewController *) menuViewController
                     iconBtnMenu:(UIImage *) iconMenu
             iconBtnMenuSelected:(UIImage *) iconMenuSelected
        directAccesMenuPermanent:(BOOL) flagDirectAccesMenuPermanent {
    
    NSAssert(rootViewController!=nil, @"rootViewController is nil !!!");
    NSAssert(menuViewController!=nil, @"menuViewController is nil !!!");
    NSAssert(iconMenu!=nil, @"iconMenu is nil !!!");
    NSAssert(iconMenuSelected!=nil, @"iconMenuSelected is nil !!!");

    self.iconBtnMenu = iconMenu;
    self.iconBtnMenuSelected = iconMenuSelected;
    self.flagPermanentDirectAccesMenu = flagDirectAccesMenuPermanent;
    
    return [self initWithRootViewController:rootViewController
                      andMenuViewController:menuViewController];
}

-(id) initWithRootViewController:(UIViewController *)rootViewController
           andMenuViewController:(UIViewController *)menuViewController {

    if (self = [super initWithNibName:nil bundle:nil]) {
        
        flagDuringInit = YES;
        [self configureMenuViewController:menuViewController];
        [self pushViewController:rootViewController animated:NO];
    }
    
    return self;
}


-(void) accesDirectMenu:(id) sender {
    
    //NSLog (@"accesDirectMenu sender=%@ ...", [sender class]);

    UIViewController *top = self.topViewController;
    top.hpNavItem.visiblePartialOverMenuView = YES;
    
    [self popViewControllerAndHierarchyAnimated:YES];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    static Class reorderControlClass;
    if (!reorderControlClass) {
        reorderControlClass = NSClassFromString(@"UITableViewCellReorderControl");
    }
    return ![touch.view isKindOfClass:[UISlider class]] && ![touch.view isKindOfClass:reorderControlClass];
}


@end
