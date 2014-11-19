//
//  KKBookAboutVC.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 19/11/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookAboutVC.h"
#import "FileHelper.h"

@interface KKBookAboutVC ()<UIWebViewDelegate>

@end

@implementation KKBookAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self addCloseBarButtonItem];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWebView{
    NSURL *url = [NSURL fileURLWithPath:[[FileHelper bundlePath] stringByAppendingPathComponent:@"about.html"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

//-(void)addCloseBarButtonItem{
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissNavigationController)];
//    self.navigationItem.leftBarButtonItem = closeButton;
//}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showProgress];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissProgress];
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
