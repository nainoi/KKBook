//
//  KKBookPreviewVCViewController.h
//  KKBooK
//
//  Created by PromptNow Ltd. on 12/11/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKBookPreviewVC : UIViewController<UIPageViewControllerDataSource>

@property(strong, nonatomic) UIPageViewController *pageViewControler;
@property(strong, nonatomic) NSArray *previews;

@end
