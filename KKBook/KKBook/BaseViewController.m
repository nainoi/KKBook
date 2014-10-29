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

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBar{
    NSLog(@"%@", self.navigationController);
    ((BaseNavigationController*)self.navigationController).navigationBar.tintColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:130/255.0 alpha:1.0];
    ((BaseNavigationController*)self.navigationController).navigationBar.tintColor = [UIColor redColor];
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
