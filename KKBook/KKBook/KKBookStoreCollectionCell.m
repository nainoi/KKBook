//
//  KKBookStoreCollectionCell.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 31/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookStoreCollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation KKBookStoreCollectionCell{
    UIImage *cover;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor redColor];
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_coverImageView];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.numberOfLines = 0;
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_priceLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
    }
    return self;

}

- (CGSize)labelSizeForString:(NSString *)string {
    CGSize maximumLabelSize = CGSizeMake(CELL_WIDTH, FLT_MAX);
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey: NSFontAttributeName];
    CGSize expectedLabelSize = [string boundingRectWithSize:maximumLabelSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:nil].size;
    
    return expectedLabelSize;
}

-(void)setBookModel:(BookModel *)bookModel{
    _bookModel = bookModel;
    [self loadImageWithUrl];
}

-(void)loadImageWithUrl{
    if (_bookModel.coverImageURL) {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = self.coverImageView;
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_bookModel.coverImageURL]
                           placeholderImage:[UIImage imageNamed:@"phone.jpg"]
                                    options:SDWebImageProgressiveDownload
                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                       if (!activityIndicator) {
                                           [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                           activityIndicator.center = weakImageView.center;
                                           [activityIndicator startAnimating];
                                       }
                                   }
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      cover = image;
                                      if (!cover) {
                                          cover = [UIImage imageNamed:@"phone.jpg"];
                                      }
                                      [activityIndicator removeFromSuperview];
                                      activityIndicator = nil;
                                  }];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if (!cover) {
        cover = [UIImage imageNamed:@"phone.jpg"];
    }
    CGSize rctSizeOriginal = cover.size;
    double scale = (self.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    _coverImageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);
    
    CGRect priceFrame = CGRectMake(kCollectionCellBorderLeft, CGRectGetMaxY(_coverImageView.frame),rctSizeFinal.width,20);
    [_priceLabel setText:_bookModel.price];
    [_priceLabel setFrame:priceFrame];
    
    CGRect nameFrame = CGRectMake(kCollectionCellBorderLeft,CGRectGetMaxY(_priceLabel.frame),rctSizeFinal.width,[self labelSizeForString:_bookModel.bookName].height);
    [_nameLabel setText:_bookModel.bookName];
    [_nameLabel setFrame:nameFrame];
    
    CGRect fram = self.frame;
    fram.size.height = CGRectGetMaxY(_nameLabel.frame) + 5;
    self.frame = fram;
}

@end
