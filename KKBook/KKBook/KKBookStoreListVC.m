//
//  KKBookStoreListVC.m
//  KKBooK
//
//  Created by PromptNow on 11/11/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookStoreListVC.h"
#import "CategoryListTVC.h"
#import "StoreListCell.h"
#import "UIAlertView+AFNetworking.h"
#import "BookModel.h"

@interface KKBookStoreListVC (){
    NSArray *categories;
}

@end

@implementation KKBookStoreListVC

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
        //            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
        UINib *nib = [UINib nibWithNibName:StoreListCell_NIB bundle: nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:StoreListCell_NIB];
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.collectionView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"ALL BOOK";
    [self hiddenBackTitle];
    [self requestCategory];
    [self requestListBook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)arrangeCollectionView {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    //    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    //        flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    //    } else {
    //        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    //    }
    flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self arrangeCollectionView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self arrangeCollectionView];
}

-(void)addButtonNavigation{
    UIBarButtonItem *categoryBtn = [[UIBarButtonItem alloc] initWithTitle:@"Category" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectedCategory:)];
    self.navigationItem.rightBarButtonItem = categoryBtn;
}

-(void)didSelectedCategory:(id)sender{
    CategoryListTVC *categoryTbv = [[CategoryListTVC alloc] init];
    categoryTbv.categories = categories;
    _popoverViewController = [[UIPopoverController alloc] initWithContentViewController:categoryTbv];
    
    _popoverViewController.popoverContentSize = CGSizeMake(320.0, 400.0);
    
    [_popoverViewController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [_myBook count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StoreListCell *cell = (StoreListCell*)[cv dequeueReusableCellWithReuseIdentifier:StoreListCell_NIB forIndexPath:indexPath];
    
    BookModel *item = _myBook[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setBookModel:item];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [[UICollectionReusableView alloc] init];
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([Utility isPad]) {
        return CGSizeMake(155, 275);
    }else{
        return CGSizeMake(155, 275);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self delegate]) {
        [[self delegate] storeListSelectBook:_myBook[indexPath.row]];
    }
}

#pragma mark - request book

-(void)requestListBook{
    [self showProgressLoading];
    NSURLSessionTask *task = [KKBookService listAllBookService:^(NSArray *array, NSError *error) {
        [self dismissProgress];
        if (!error) {
            _myBook = [[NSMutableArray alloc] initWithArray:array];
            [self.collectionView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

-(void)requestCategory{
    //[self showProgressLoading];
    NSURLSessionTask *task = [KKBookService requestCategoryService:^(NSArray *array, NSError *error) {
        //[self dismissProgress];
        if (!error) {
            [self addButtonNavigation];
            categories = [NSArray arrayWithArray:array];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

@end
