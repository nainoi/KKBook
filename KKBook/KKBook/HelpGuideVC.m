//
//  HelpGuideVC.m
//  KKBooK
//
//  Created by GLIVE on 9/10/2558 BE.
//  Copyright (c) 2558 GLive. All rights reserved.
//

#import "HelpGuideVC.h"

@interface HelpGuideVC ()

@end

@implementation HelpGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self addCloseBarButtonItem];
    //UIImage * img = [UIImage imageNamed:@"manaul.jpg"];
    CGSize imgSize = self.view.frame.size;
    imgSize.height = [self scaleImageAutoLayout:_imageView withWidth:self.view.frame.size.width];
    //imgSize.width = [UIScreen mainScreen].bounds.size.width;
    _imageView.frame = CGRectMake(0, 0, imgSize.width, imgSize.height);
    _scrollView.contentSize = imgSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) scaleImageAutoLayout:(UIImageView *)imageView withWidth:(CGFloat)width
{
    CGFloat scale = width/imageView.image.size.width;
    CGFloat height = imageView.image.size.height * scale;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(imageView);
    [imageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString     stringWithFormat:@"V:[imageView(%f)]",ceilf(height)]
                                                                      options:0 metrics:nil    views:viewsDictionary]];
    return height;
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
