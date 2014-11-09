//
//  KKBookLibraryCell.h
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookEntity.h"

#define LIBRARY_CELL [Utility isPad] ? @"KKBookLibraryCell" : @"KKBookLibraryCell_Phone"

@interface KKBookLibraryCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelIssue;
@property (strong, nonatomic) IBOutlet UIProgressView *progresView;
@property (strong, nonatomic) BookEntity *bookEntity;

@end
