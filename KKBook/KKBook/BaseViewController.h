//
//  BaseViewController.h
//  KKBooK
//
//  Created by PromptNow on 10/29/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setNavigationBar;

//progress
-(void)showProgressLoading;
-(void)dismissProgress;

@end
