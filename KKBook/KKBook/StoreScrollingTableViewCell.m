//
//  PPScrollingTableViewCell.m
//  PPImageScrollingTableViewControllerDemo
//
//  Created by popochess on 13/8/10.
//  Copyright (c) 2013年 popochess. All rights reserved.
//

#import "StoreScrollingTableViewCell.h"
#import "PPImageScrollingCellView.h"
#import "BookModel.h"

#define kScrollingViewHieght 190
#define kCategoryLabelWidth 200
#define kCategoryLabelHieght 30
#define kStartPointY 30

@interface StoreScrollingTableViewCell() <PPImageScrollingViewDelegate>

@property (strong,nonatomic) UIColor *categoryTitleColor;
@property(strong, nonatomic) PPImageScrollingCellView *imageScrollingView;
@property (strong, nonatomic) NSString *categoryLabelText;

@end

@implementation StoreScrollingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    // Set ScrollImageTableCellView
    _imageScrollingView = [[PPImageScrollingCellView alloc] initWithFrame:CGRectMake(0., kStartPointY, CHILD_WIDTH, kScrollingViewHieght)];
    _imageScrollingView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state
}

- (void)setCategoryData:(NSDictionary*)collection
{
    if (![collection isKindOfClass:[NSNull class]]) {
        NSLog(@"collection %@",collection);
        if ([collection objectForKey:@"book"] != [NSNull null]) {
            [_imageScrollingView setBookData:[collection objectForKey:@"book"]];
            _categoryLabelText = [collection objectForKey:@"category"];
        }
    }
}

- (void)setCategoryLabelText:(NSString*)text withColor:(UIColor*)color{
    
    if ([self.contentView subviews]){
        for (UIView *subview in [self.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    UILabel *categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kCategoryLabelWidth, kCategoryLabelHieght)];
    categoryTitle.textAlignment = NSTextAlignmentLeft;
    categoryTitle.text = text;
    categoryTitle.textColor = color;
    categoryTitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:categoryTitle];
}
    
- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height {

    [_imageScrollingView setImageTitleLabelWitdh:width withHeight:height];
}

- (void) setImageTitleTextColor:(UIColor *)textColor withBackgroundColor:(UIColor *)bgColor{

    [_imageScrollingView setImageTitleTextColor:textColor withBackgroundColor:bgColor];
}

- (void)setCollectionViewBackgroundColor:(UIColor *)color{
    
    _imageScrollingView.backgroundColor = color;
    [self.contentView addSubview:_imageScrollingView];
}

-(void)collectionView:(PPImageScrollingCellView *)collectionView didSelectBook:(BookModel *)book{
    if ([self delegate]) {
        [[self delegate] scrollingTableViewCell:self didSelectBook:book];
    }
}

@end
