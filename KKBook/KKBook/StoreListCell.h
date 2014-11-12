//
//  StoreListCellCollectionViewCell.h
//  KKBooK
//
//  Created by PromptNow on 11/11/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

#define StoreListCell_NIB @"StoreListCell"

@interface StoreListCell : UICollectionViewCell

@property(strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property(strong, nonatomic) IBOutlet UILabel *priceLb;
@property(strong, nonatomic) IBOutlet UILabel *nameLb;
@property(strong, nonatomic) IBOutlet UILabel *typeLb;
@property(strong, nonatomic) BookModel *bookModel;

@end
