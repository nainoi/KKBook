//
//  UINavigationController+Transition.h
//  SCBEASY
//
//  Created by Ittipong on 4/4/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transition)

- (void)pushViewControllerMoveToTop:(UIViewController *)viewController;
- (void)pushViewControllerMoveToBottom:(UIViewController *)viewController;
- (void)popViewControllerMoveToBottom;

@end
