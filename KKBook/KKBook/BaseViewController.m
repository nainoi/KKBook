//
//  BaseViewController.m
//  KKBooK
//
//  Created by PromptNow on 10/29/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "BaseNavigationBar.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation bar

-(void)hiddenBackTitle{
    ((UINavigationItem*)self.navigationController.navigationBar.items[0]).title = @"";
}

- (void)addBackNavigation{
    ((BaseNavigationController*)self.navigationController).navigationItem.backBarButtonItem.title = @"";
    NSLog(@"bact title %@",((BaseNavigationController*)self.navigationController).navigationItem.leftBarButtonItem);
}

- (void)setNavigationBar{
    ((BaseNavigationController*)self.navigationController).navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:130/255.0 alpha:1.0];
}

#pragma mark - progress

-(void)showProgressLoading{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [HUD show:YES];
}

-(void)dismissProgress{
    [HUD hide:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
