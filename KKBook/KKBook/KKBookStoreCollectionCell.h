//
//  KKBookStoreCollectionCell.h
//  KKBooK
//
//  Created by PromptNow Ltd. on 31/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCollectionCellBorderTop 17.0
#define kCollectionCellBorderBottom 17.0
#define kCollectionCellBorderLeft 17.0
#define kCollectionCellBorderRight 17.0

@interface KKBookStoreCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) NSDictionary *book;

@end
