//
//  BaseViewController.h
//  KKBooK
//
//  Created by PromptNow on 10/29/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//navigation
-(void)hiddenBackTitle;
-(void)addBackNavigation;
-(void)setNavigationBar;
-(void)addCloseBarButtonItem;

//progress
-(void)showProgressLoading;
-(void)dismissProgress;
-(void)showProgress;

//alert
+(void)showAlertWithMessage:(NSString*)message;
+(void)showAlertNotConnectInternet;

@end
