//
//  PPScrollingTableViewCell.h
//  PPImageScrollingTableViewControllerDemo
//
//  Created by popochess on 13/8/10.
//  Copyright (c) 2013年 popochess. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreScrollingTableViewCell;
@class BookModel;

@protocol StoreScrollingTableViewCellDelegate <NSObject>

// Notifies the delegate when user click image

- (void)scrollingTableViewCell:(StoreScrollingTableViewCell *)scrollingTableViewCell didSelectBook:(BookModel*)book;

@end

@interface StoreScrollingTableViewCell : UITableViewCell

@property (weak, nonatomic) id<StoreScrollingTableViewCellDelegate> delegate;
@property (nonatomic) CGFloat height;

- (void) setCategoryData:(NSDictionary*)collection;
- (void) setCollectionViewBackgroundColor:(UIColor*) color;
- (void) setCategoryLabelText:(NSString*)text withColor:(UIColor*)color;
- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;

@end