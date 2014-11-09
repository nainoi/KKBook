//
//  KKBookStoreCollectionCell.h
//  KKBooK
//
//  Created by PromptNow Ltd. on 31/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_WIDTH 130

#define kCollectionCellBorderTop 15.0
#define kCollectionCellBorderBottom 20.0
#define kCollectionCellBorderLeft 10.0
#define kCollectionCellBorderRight 10.0

@interface KKBookStoreCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) NSDictionary *book;

@end
