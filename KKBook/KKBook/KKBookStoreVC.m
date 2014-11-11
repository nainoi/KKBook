//
//  KKBookStoreVC.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 29/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookStoreVC.h"
//#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import "KKBookStoreCollectionCell.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImage+WebP.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface KKBookStoreVC (){
    UIImage *cover;
}

@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (strong, nonatomic) NSMutableArray *books;

@end

@implementation KKBookStoreVC

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        layout.headerHeight = 15;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 5;
        layout.minimumInteritemSpacing = 20;
        layout.columnCount = [Utility isPad] ? 4 : 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
//            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[KKBookStoreCollectionCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

-(void)fillSizeArray
{
    for (int i=0; i<[self.books count]; i++)
    {
        NSNumber *width = [NSNumber numberWithFloat:200];
        NSNumber *height = [NSNumber numberWithFloat:200];
        
        BookModel *book = _books[i];
        NSString *urlString = book.coverImageURL;
        NSURL *imageFileURL = [NSURL URLWithString:urlString];
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageFileURL, NULL);
        CGSize rctSizeFinal = CGSizeZero;
        if (imageSource) {
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache, nil];
            CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
            if (imageProperties) {
                width = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
                height = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
                
                
                CGSize textSize = [self labelSizeForString:book.bookName];
                double scale = (CELL_WIDTH  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / [width floatValue];
                rctSizeFinal = CGSizeMake([width floatValue]*scale ,([height floatValue] * scale)+(textSize.height));
                NSLog(@"Image dimensions: %f x %f px", rctSizeFinal.width, rctSizeFinal.height);
                CFRelease(imageProperties);
            }
        }
        _cellSizes[i] = [NSValue valueWithCGSize:rctSizeFinal];
    }
}

//- (NSMutableArray *)cellSizes {
//    if (!_cellSizes) {
//        _cellSizes = [NSMutableArray array];
//        for (NSInteger i = 0; i < CELL_COUNT; i++) {
//            CGSize size = CGSizeMake(arc4random() % 50 + 50, arc4random() % 50 + 50);
//            _cellSizes[i] = [NSValue valueWithCGSize:size];
//        }
//    }
//    return _cellSizes;
//}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestListBook];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    //layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
    layout.columnCount = [Utility isPad] ? 4 : 2;
}

#pragma mark - request book

-(void)requestListBook{
    [self showProgressLoading];
    NSURLSessionTask *task = [KKBookService listAllBookService:^(NSArray *array, NSError *error) {
        [self dismissProgress];
        if (!error) {
            _books = [[NSMutableArray alloc] initWithArray:array];
            [self fillSizeArray];
            [self.collectionView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

#pragma mark - UICollectionViewDataSource

//- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
//{
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_books count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CHTCollectionViewWaterfallCell *cell =
//    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
//                                                                                forIndexPath:indexPath];
//    cell.displayString = [NSString stringWithFormat:@"cell %ld", (long)indexPath.item];
//    return cell;
    KKBookStoreCollectionCell *cell =
    (KKBookStoreCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    BookModel *model = _books[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.bookModel = model;
    //cell.displayString = [NSString stringWithFormat:@"cell %ld", (long)indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.section + 1 * indexPath.item] floatValue];
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return /* a different size if the image is done downloading yet */;
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item] CGSizeValue];
    return CGSizeMake(200.0, 180.0);
}

-(CGSize)computeSizeForRowAtIndexPath:(NSIndexPath*)indexPath{
//    KKBookStoreCollectionCell *cell = (KKBookStoreCollectionCell*)[_collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
//    cell = (KKBookStoreCollectionCell*)[_collectionView cellForItemAtIndexPath:indexPath];
    BookModel *book = _books[indexPath.row];
    CGSize size = cover.size;
    CGSize textSize = [self labelSizeForString:book.bookName];
    double scale = (CELL_WIDTH  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / size.width;
    CGSize rctSizeFinal = CGSizeMake(size.width*scale ,(size.height * scale)+(textSize.height));
    return rctSizeFinal;
}

- (CGSize)labelSizeForString:(NSString *)string {
    CGSize maximumLabelSize = CGSizeMake(CELL_WIDTH-5, FLT_MAX);
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey: NSFontAttributeName];
    CGSize expectedLabelSize = [string boundingRectWithSize:maximumLabelSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:nil].size;
    
    return expectedLabelSize;
}

@end
