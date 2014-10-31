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

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface KKBookStoreVC ()

@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (strong, nonatomic) NSMutableArray *books;

@end

@implementation KKBookStoreVC

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 15;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 10;
        
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

- (NSMutableArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = [NSMutableArray array];
        for (NSInteger i = 0; i < CELL_COUNT; i++) {
            CGSize size = CGSizeMake(arc4random() % 50 + 50, arc4random() % 50 + 50);
            _cellSizes[i] = [NSValue valueWithCGSize:size];
        }
    }
    return _cellSizes;
}

-(void)initArray{
    NSArray *data = @[@{@"price":@"FREE", @"image":@"phone.jpg", @"name":@"Hello world"},
                      @{@"price":@"FREE", @"image":@"cat2.jpg", @"name":@"สวนเรืองแสง"},
                      @{@"price":@"120", @"image":@"cat4.jpg", @"name":@"Note that it’s not needed to include the ending"},
                      @{@"price":@"299", @"image":@"cat3.jpg", @"name":@"Hello world"},
                      @{@"price":@"FREE", @"image":@"phone.jpg", @"name":@"Hello world"},
                      @{@"price":@"FREE", @"image":@"cat1.jpg", @"name":@"Hello world"},
                      @{@"price":@"FREE", @"image":@"cat1.jpg", @"name":@"documentation"},
                      @{@"price":@"FREE", @"image":@"cat3.jpg", @"name":@"วัฒนธรรมอีสาน ตำนานผาแดงนางไอ่"},
                      @{@"price":@"399", @"image":@"phone.jpg", @"name":@"Hello world"},
                      @{@"price":@"FREE", @"image":@"cat3.jpg", @"name":@"งานไหมและงานผูกเสี่ยว"},
                      @{@"price":@"FREE", @"image":@"cat1.jpg", @"name":@"เที่ยวธรรมชาติที่ภูกระดึง"},
                      @{@"price":@"2999", @"image":@"phone.jpg", @"name":@"วัฒนธรรมอีสาน ตำนานผาแดงนางไอ่"}];
    _books = [[NSMutableArray alloc] initWithArray:data];
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArray];
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
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
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
    cell.book = _books[indexPath.row];
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return [self.cellSizes[indexPath.item] CGSizeValue];
    return [self computeSizeForRowAtIndexPath:indexPath.item];
}

-(CGSize)computeSizeForRowAtIndexPath:(NSInteger)index{
    NSDictionary *dic = _books[index];
    CGSize size = [UIImage imageNamed:dic[@"image"]].size;
    CGSize textSize = [self labelSizeForString:dic[@"name"]];
    float height = size.height + kCollectionCellBorderTop + kCollectionCellBorderBottom ;
    double scale = (120  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / size.width;
    CGSize rctSizeFinal = CGSizeMake(size.width * scale,(size.height * scale)+textSize.height);
    size.height = height;
    size.width = 120;
    return rctSizeFinal;
}

- (CGSize)labelSizeForString:(NSString *)string {
    CGSize maximumLabelSize = CGSizeMake(120, FLT_MAX);
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey: NSFontAttributeName];
    CGSize expectedLabelSize = [string boundingRectWithSize:maximumLabelSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:nil].size;
    
    return expectedLabelSize;
}

@end
