//
//  KKBookStorList.m
//  KKBooK
//
//  Created by PromptNow on 11/4/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookStoreMain.h"
#import "BannerModel.h"

@interface KKBookStoreMain ()

@end

@implementation KKBookStoreMain

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBannerView{
    _myPageDataArray = [[NSMutableArray alloc] initWithCapacity : 4];
    
    for (int i=1; i<=4; i++) {
        BannerModel *banner = [[BannerModel alloc] init];
        banner.bannerImage = [NSString stringWithFormat:@"image%d", i];
        [_myPageDataArray addObject:banner];
    }
    
    // now that we have the data, initialize the page scroll view
    _myPageScrollView = [[[NSBundle mainBundle] loadNibNamed:HGPageScrollViewNIB owner:self options:nil] objectAtIndex:0];
    CGRect frame = _myPageScrollView.frame;
    frame.origin.y = 20;
    frame.size.width = CGRectGetWidth(self.view.bounds);
    _myPageScrollView.frame = frame;
    _myPageScrollView.delegate = self;
    _myPageScrollView.dataSource = self;
    [self.view addSubview:_myPageScrollView];

}

#pragma mark -
#pragma mark HGPageScrollViewDataSource


- (NSInteger)numberOfPagesInScrollView:(HGPageScrollView *)scrollView;   // Default is 0 if not implemented
{
    return [_myPageDataArray count];
}


- (HGPageView *)pageScrollView:(HGPageScrollView *)scrollView viewForPageAtIndex:(NSInteger)index;
{
    
    BannerModel *banner = [_myPageDataArray objectAtIndex:index];
    UIImage *image = [UIImage imageNamed:banner.bannerImage];
    CGSize imageSize = [image size];
    CGRect frame = CGRectMake(0, 0, 320, 320.0 / imageSize.width * imageSize.height);
    
    HGPageImageView *imageView = [[HGPageImageView alloc]
                                  initWithFrame:frame];
    [imageView setImage:image];
    [imageView setReuseIdentifier:@"imageId"];
    
    return imageView;
}

#pragma mark -
#pragma mark HGPageScrollViewDelegate

- (void) pageScrollView:(HGPageScrollView *)scrollView didSelectPageAtIndex:(NSInteger)index
{
}


@end
