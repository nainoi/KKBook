//
//  KKBookLibraryCell.h
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookEntity.h"

@class KKBookLibraryCell;

#define LIBRARY_CELL [Utility isPad] ? @"KKBookLibraryCell_Phone" : @"KKBookLibraryCell_Phone"

@protocol KKBookLibraryCellDelegate <NSObject>

-(void)deleteBookOnLibrary:(KKBookLibraryCell*)cell withBookEntity:(BookEntity*)bookEntity;

@end

@interface KKBookLibraryCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelIssue;
@property (strong, nonatomic) IBOutlet UIProgressView *progresView;
@property (strong, nonatomic) IBOutlet UIButton *resumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) BookEntity *bookEntity;
@property (assign, nonatomic) BOOL isDelete;
@property (assign, nonatomic) id<KKBookLibraryCellDelegate> delegate;

- (IBAction)didResume:(id)sender;
- (IBAction)didDelete:(id)sender;

@end
