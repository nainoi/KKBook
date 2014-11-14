//
//  ViewController.h
//  CurlWebView
//
//  Created by Disakul Waidee on 7/10/56 BE.
//  Copyright (c) 2556 Digix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "BookEntity.h"

@interface InteractiveReader : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@property (strong, nonatomic) BookEntity *book;
@property (assign, nonatomic) NSInteger currenCh;
@property (assign, nonatomic) NSInteger currentSec;

-(id)initWithBook:(BookEntity*)book;
-(void)gotoPage:(NSInteger)ch sec:(NSInteger)sec page:(NSInteger)page;


@end
