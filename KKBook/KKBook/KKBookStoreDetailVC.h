//
//  KKBookStoreDetailVC.h
//  KKBooK
//
//  Created by PromptNow on 11/6/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
#import "KKBookView.h"
#import "AAShareBubbles.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Twitter/Twitter.h>

#define KKBookStoreDetailXIB [Utility isPad] ? @"KKBookStoreDetailVCPad" :@"KKBookStoreDetailVCPhone"

@interface KKBookStoreDetailVC : BaseViewController<AAShareBubblesDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet KKBookView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLb;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *publisherTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *authorTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *categoryLb;
@property (weak, nonatomic) IBOutlet UILabel *publisherLb;
@property (weak, nonatomic) IBOutlet UILabel *auhorLb;
@property (weak, nonatomic) IBOutlet UIView *line1View;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *coverPriceTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *totalPageTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLb;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLb;
@property (weak, nonatomic) IBOutlet UIView *line2View;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;

@property (strong, nonatomic) BookModel *book;
@property (copy, nonatomic) void (^didDownload)(BookModel*);
@property (copy, nonatomic) void (^didOpen)(BookModel*);

- (instancetype)initWithBook:(BookModel*)book;

- (IBAction)didPriceBtn:(id)sender;
- (IBAction)didPreviewBtn:(id)sender;
- (IBAction)didShareBtn:(id)sender;

@end
