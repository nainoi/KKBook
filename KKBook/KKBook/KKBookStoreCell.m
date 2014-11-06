//
//  KKBookLibraryCell.m
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookStoreCell.h"
#import "UIImageView+WebCache.h"

@implementation KKBookStoreCell{
    NSURL *imageURL;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)setBookModel:(BookModel *)bookModel{
    _bookModel = bookModel;
    imageURL = [NSURL URLWithString:[Utility isPad] ? _bookModel.padImageURL : _bookModel.phoneImageURL];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_imageCover sd_setImageWithURL:imageURL placeholderImage:nil];
    
    self.labelTitle.textColor = [UIColor colorWithRed:0.18f green:0.20f blue:0.23f alpha:1.00f];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    
    self.labelIssue.textColor = [UIColor colorWithRed:1.00f green:0.25f blue:0.55f alpha:1.00f];
    self.labelIssue.backgroundColor = [UIColor clearColor];
    
}

@end
