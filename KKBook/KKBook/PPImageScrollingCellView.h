//
//  PPImageScrollingCellView.h
//  PPImageScrollingTableViewDemo
//
//  Created by popochess on 13/8/9.
//  Copyright (c) 2013年 popochess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BookModel.h"

@class PPImageScrollingCellView;

@protocol PPImageScrollingViewDelegate <NSObject>

- (void)collectionView:(PPImageScrollingCellView *)collectionView didSelectBook:(BookModel*)book;

@end


@interface PPImageScrollingCellView : UIView

@property (weak, nonatomic) id<PPImageScrollingViewDelegate> delegate;

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;
- (void) setBookData:(NSArray*)collectionBookData;
- (void) setBackgroundColor:(UIColor*)color;

@end
