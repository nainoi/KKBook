//
//  KKBookStoreDetailVC.m
//  KKBooK
//
//  Created by PromptNow on 11/6/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookStoreDetailVC.h"
#import "UIImageView+WebCache.h"
#import "KKBookService.h"
#import "UIAlertView+AFNetworking.h"
#import "KKBookPreviewVC.h"

@interface KKBookStoreDetailVC ()

@end

@implementation KKBookStoreDetailVC

-(instancetype)initWithBook:(BookModel *)book{
    JLLog(@"%@",KKBookStoreDetailXIB);
    self = [super initWithNibName:KKBookStoreDetailXIB bundle:nil];
    if (self) {
        self.book = book;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [self setNavigationBar];
    [self hiddenBackTitle];
    [self initBookData];
    
    //NSLog(@"bact title %@",((UINavigationItem*)self.navigationController.navigationBar.items[0]).title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBookData{
    
    self.title = _book.bookName;
    self.bookNameTitle.text = _book.bookName;
    self.bookNameLb.text = _book.bookName;
    self.categoryLb.text = _book.categoryName;
    self.publisherLb.text = _book.publisherDisplay;
    self.auhorLb.text = _book.authorDisplay;
    [self.priceBtn setTitle:_book.priceDisplay forState:UIControlStateNormal];
    self.totalPageLb.text = _book.page;
    self.fileSizeLb.text = _book.fileSizeDisplay;
    self.detailLb.text = _book.bookDesc;
    self.priceLb.text = [_book.coverPrice stringByAppendingString:@" ฿"];
    
    _detailLb.numberOfLines = 0;
    [_detailLb sizeToFit];
    
    [self loadImageWithUrl];
}

-(void)loadImageWithUrl{
    if (_book.coverImageDetailBookURL) {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = self.coverImageView;
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_book.coverImageDetailBookURL]
                          placeholderImage:nil
                                   options:SDWebImageProgressiveDownload
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      if (!activityIndicator) {
                                          [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                          activityIndicator.center = weakImageView.center;
                                          [activityIndicator startAnimating];
                                      }
                                  }
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     [activityIndicator removeFromSuperview];
                                     activityIndicator = nil;
                                 }];
    }
}

- (IBAction)didPriceBtn:(id)sender {
    [self download];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPreviewBtn:(id)sender {
    [self loadPreview];
}

- (IBAction)didShareBtn:(id)sender {
}

-(void)download{
    if (self.didDownload) {
        self.didDownload(_book);
    }
}

#pragma mark - Service

-(void)loadPreview{
    [self showProgressLoading];
    NSURLSessionTask *task = [KKBookService requestPreviewServiceWithBook:_book.bookID complete:^(NSArray *array, NSError *error){
        [self dismissProgress];
        if (!error) {
            KKBookPreviewVC *previewVC = [[KKBookPreviewVC alloc] init];
            previewVC.previews = array;
            [self.navigationController pushViewController:previewVC animated:YES];
        }else{
            [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
        }
        
    }];
}

@end
