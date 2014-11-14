//
//  ContentViewController.h
//  CurlWebView
//
//  Created by Disakul Waidee on 7/10/56 BE.
//  Copyright (c) 2556 Digix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) id dataObject;

@end
