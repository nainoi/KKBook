//
//  KKBookMainVC.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 30/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookMainVC.h"
#import "KKBookStoreVC.h"
#import "KKBookLeftSidebar.h"

@interface KKBookMainVC ()<KKBookLeftSidebarDelegate>{
    KKBookStoreVC *storeVC;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) KKBookLeftSidebar *leftSideBar;

@end

@implementation KKBookMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //init
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    storeVC = [[KKBookStoreVC alloc] init];
    [self setNavigationBar];
    [self setMainMenuItem];
    [self initMainViewController];
    [self toggleViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMainViewController{
    self.mainController = [[UIViewController alloc] init];
    CGRect frame = self.view.bounds;
    frame.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    frame.size.height = CGRectGetHeight(frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _mainController.view.frame = frame;
    _mainController.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainController.view];
    _pageType = STORE;
}

#pragma mark - top view

-(void)toggleViewController{
    CGRect frame = _mainController.view.bounds;
    frame.origin.y = 0;
    switch (_pageType) {
        case STORE:
            storeVC.view.frame = frame;
            self.title = @"KKBook";
            [_mainController.view addSubview:storeVC.view];
            break;
            
        default:
            break;
    }
}

#pragma mark - left menu

-(void)setMainMenuItem{
    UIImage *mainMenuImage = [UIImage imageNamed:@"ic_menu.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.reversesTitleShadowWhenHighlighted = YES;
    [button setImage:mainMenuImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, 40.0, 30.0);
    [button addTarget:self action:@selector(tapLeftMainMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mainMenu = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = mainMenu;
}

-(void)tapLeftMainMenu{
    if (!_leftSideBar) {
        NSArray *images = @[
                            [UIImage imageNamed:@"gear"],
                            [UIImage imageNamed:@"globe"],
                            [UIImage imageNamed:@"profile"],
                            [UIImage imageNamed:@"star"],
                            ];
        NSArray *colors = @[
                            [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                            [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                            [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                            [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                            ];
        
        KKBookLeftSidebar *callout = [[KKBookLeftSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
        _leftSideBar = callout;
        callout.delegate = self;

    }
       //    callout.showFromRight = YES;
    [_leftSideBar show];

}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(KKBookLeftSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    if (index == 3) {
        [sidebar dismissAnimated:YES completion:nil];
    }
}

- (void)sidebar:(KKBookLeftSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
}
@end
