//
//  UINavigationController+Transition.m
//  SCBEASY
//
//  Created by Ittipong on 4/4/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import "AppDelegate.h"
@implementation UINavigationController (Transition)

- (void)pushViewControllerMoveToTop:(UIViewController *)viewController {
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.40;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:NO];
}
- (void)pushViewControllerMoveToBottom:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.40;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:NO];
}
- (void)popViewControllerMoveToBottom; {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.40;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popViewControllerAnimated:NO];
}
-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
