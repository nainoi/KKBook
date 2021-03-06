//
//  StoreListCellCollectionViewCell.m
//  KKBooK
//
//  Created by PromptNow on 11/11/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "StoreListCell.h"
#import "UIImageView+WebCache.h"

@implementation StoreListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setBookModel:(BookModel *)bookModel{
    _bookModel = bookModel;
    _priceLb.text = [_bookModel priceDisplay];
    _nameLb.text = [_bookModel bookName];
    _typeLb.text = [_bookModel fileTypeName];
    [self loadImageWithUrl];
}

-(void)loadImageWithUrl{
    if (_bookModel.coverImageURL) {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = self.coverImageView;
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_bookModel.coverImageURL]
                           placeholderImage:[UIImage imageNamed:@"stub"]
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

-(void)layoutSubviews{
    [super layoutSubviews];
    _priceLb.textColor = [UIColor KKBookOrangeColor];
    _typeLb.textColor = [UIColor grayColor];
    _coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _coverImageView.layer.shadowRadius = 3.0f;
    _coverImageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    _coverImageView.layer.shadowOpacity = 0.5f;
}


@end
