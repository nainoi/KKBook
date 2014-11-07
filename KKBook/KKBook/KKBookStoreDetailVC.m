//
//  KKBookStoreDetailVC.m
//  KKBooK
//
//  Created by PromptNow on 11/6/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookStoreDetailVC.h"
#import "UIImageView+WebCache.h"

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
    //[self initBookData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBookData{
    self.bookNameTitle.text = _book.bookName;
    self.bookNameLb.text = _book.bookName;
    self.categoryLb.text = @"category";
    self.publisherLb.text = _book.publisherDisplay;
    self.auhorLb.text = _book.authorDisplay;
    [self.priceBtn setTitle:_book.priceDisplay forState:UIControlStateNormal];
    self.totalPageLb.text = _book.page;
    self.fileSizeLb.text = _book.fileSizeDisplay;
    self.detailLb.text = _book.bookDesc;
    [self.coverImageView sd_setImageWithURL:_book.coverImageDetailBookURL placeholderImage:nil];
}

- (IBAction)didPriceBtn:(id)sender {
}

- (IBAction)didPreviewBtn:(id)sender {
}

- (IBAction)didShareBtn:(id)sender {
}
@end
