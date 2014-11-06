//
//  KKBookLibraryCell.h
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

#define STORE_CELL [Utility isPad] ? @"KKBookStoreCell" : @"KKBookStoreCell"

@interface KKBookStoreCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelIssue;
@property (strong, nonatomic) BookModel *bookModel;

@end
