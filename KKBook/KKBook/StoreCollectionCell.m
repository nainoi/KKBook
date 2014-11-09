//
//  StoreCollectionCell.m
//  KKBooK
//
//  Created by PromptNow on 11/8/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "StoreCollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation StoreCollectionCell

-(void)awakeFromNib
{
    
}

-(void)setBookModel:(BookModel *)bookModel{
    _bookModel = bookModel;
    [self loadImageWithUrl];
}

-(void)loadImageWithUrl{
    if (_bookModel.coverImageURL) {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = self.imageCover;
        [self.imageCover sd_setImageWithURL:[NSURL URLWithString:_bookModel.coverImageURL]
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


- (void)layoutSubviews {
    [super layoutSubviews];
    //[_imageCover sd_setImageWithURL:imageURL placeholderImage:nil];
    
    self.labelTitle.textColor = [UIColor colorWithRed:0.18f green:0.20f blue:0.23f alpha:1.00f];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    
    self.labelIssue.textColor = [UIColor colorWithRed:1.00f green:0.25f blue:0.55f alpha:1.00f];
    self.labelIssue.backgroundColor = [UIColor clearColor];
    
}

@end
