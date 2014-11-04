//
//  KKBookStoreCollectionCell.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 31/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookStoreCollectionCell.h"




@implementation KKBookStoreCollectionCell{
    UIImage *cover;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
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

-(void)setBook:(NSDictionary *)book{
    _book = book;
    
    cover = [UIImage imageNamed:_book[@"image"]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize rctSizeOriginal = cover.size;
    double scale = (self.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    [_coverImageView setImage:cover];
    _coverImageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);
    
    CGRect priceFrame = CGRectMake(kCollectionCellBorderLeft, CGRectGetMaxY(_coverImageView.frame),rctSizeFinal.width,20);
    [_priceLabel setText:_book[@"price"]];
    [_priceLabel setFrame:priceFrame];
    
    CGRect nameFrame = CGRectMake(kCollectionCellBorderLeft,CGRectGetMaxY(_priceLabel.frame),rctSizeFinal.width,[self labelSizeForString:_book[@"name"]].height);
    [_nameLabel setText:_book[@"name"]];
    [_nameLabel setFrame:nameFrame];
    
    CGRect fram = self.frame;
    fram.size.height = CGRectGetMaxY(_nameLabel.frame) + 5;
    self.frame = fram;
}

@end
