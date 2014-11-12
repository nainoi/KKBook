//
//  PPImageScrollingCellView.m
//  PPImageScrollingTableViewDemo
//
//  Created by popochess on 13/8/9.
//  Copyright (c) 2013年 popochess. All rights reserved.
//

#import "PPImageScrollingCellView.h"
//#import "PPCollectionViewCell.h"
#import "StoreCollectionCell.h"

@interface  PPImageScrollingCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

//@property (strong, nonatomic) PPCollectionViewCell *myCollectionViewCell;
@property (strong, nonatomic) StoreCollectionCell *storeCollectionViewCell;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSArray *collectionBookData;
@property (nonatomic) CGFloat imagetitleWidth;
@property (nonatomic) CGFloat imagetitleHeight;
@property (strong, nonatomic) UIColor *imageTilteBackgroundColor;
@property (strong, nonatomic) UIColor *imageTilteTextColor;


@end

@implementation PPImageScrollingCellView

- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code

        /* Set flowLayout for CollectionView*/
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = [Utility isPad] ? CGSizeMake(140.0, 190.0) : CGSizeMake(130.0, 170.0);
        flowLayout.sectionInset = [Utility isPad] ? UIEdgeInsetsMake(5, 20, 10, 20) : UIEdgeInsetsMake(0, 10, 5, 10);
        flowLayout.minimumLineSpacing = [Utility isPad] ? 20 : 5;

        /* Init and Set CollectionView */
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.showsHorizontalScrollIndicator = NO;

        //[self.myCollectionView registerClass:[PPCollectionViewCell class] forCellWithReuseIdentifier:@"PPCollectionCell"];
        [self.myCollectionView registerNib:[UINib nibWithNibName:STORE_CELL bundle:nil] forCellWithReuseIdentifier:STORE_CELL];
        [self addSubview:_myCollectionView];
    }
    return self;
}

- (void) setBookData:(NSArray*)collectionBookData{
    if ((NSNull*)collectionBookData != [NSNull null]) {
        _collectionBookData = collectionBookData;
        [_myCollectionView reloadData];
    }
    
}

- (void) setBackgroundColor:(UIColor*)color{

    self.myCollectionView.backgroundColor = color;
    [_myCollectionView reloadData];
}

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height{
    _imagetitleWidth = width;
    _imagetitleHeight = height;
}
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor{
    
    _imageTilteTextColor = textColor;
    _imageTilteBackgroundColor = bgColor;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionBookData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    StoreCollectionCell *cell = (StoreCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:STORE_CELL forIndexPath:indexPath];
    NSDictionary *bookDict = [self.collectionBookData objectAtIndex:[indexPath row]];
    NSLog(@"book %@",bookDict);
    BookModel *book = [[BookModel alloc] initWithAttributes:bookDict];
    [cell setBookModel:book];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StoreCollectionCell *cell = (StoreCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:STORE_CELL forIndexPath:indexPath];
    cell = (StoreCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate collectionView:self didSelectBook:cell.bookModel];
}

@end
