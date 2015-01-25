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
#import "CategoryModel.h"
#import "BaseNavigationController.h"

@interface KKBookStoreListVC (){
    NSMutableArray *categories;
    NSMutableArray *sortArray;
}

@end

@implementation KKBookStoreListVC

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.sectionInset = [Utility isPad] ? UIEdgeInsetsMake(20, 20, 20, 20) :[Utility isLessPhone5] ? UIEdgeInsetsMake(0, 1, 1, 3) : UIEdgeInsetsMake(0, 1, 1, 3);
//        layout.minimumLineSpacing = 10;
//        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = [Utility isPad] ? 40 :[Utility isLessPhone5] ? 1 : 1;
        layout.minimumInteritemSpacing = [Utility isPad] ? 20 : [Utility isLessPhone5] ? 1 : 1 ;
        
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
    [self initCategoryList];
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

-(void)initCategoryList{
    categories = [[NSMutableArray alloc] init];
    sortArray = [[NSMutableArray alloc] init];
    
    CategoryModel *category = [[CategoryModel alloc] init];
    category.categoryID = @"99";
    category.categoryName = @"ALL";
    [categories addObject:category];
    
    [self addButtonNavigation];
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
    categoryTbv.didSelectCategoryList = ^(NSString *categoryID, NSString *categoryName){
        [sortArray removeAllObjects];
        if ([categoryID intValue] == 99) {
            [sortArray addObjectsFromArray:_myBook];
        }else{
            for (BookModel *model in _myBook) {
                if ([model.categoryID intValue] == [categoryID intValue]) {
                    [sortArray addObject:model];
                }
            }

        }
        [self.collectionView reloadData];
        
        [_popoverViewController dismissPopoverAnimated:YES];
    };
    if ([Utility isPad]) {
        _popoverViewController = [[UIPopoverController alloc] initWithContentViewController:categoryTbv];
        
        _popoverViewController.popoverContentSize = CGSizeMake(320.0, 400.0);
        
        [_popoverViewController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        BaseNavigationController *naviCtrl = [[BaseNavigationController alloc] initWithRootViewController:categoryTbv];
        [self presentViewController:naviCtrl animated:YES completion:^(){
            [naviCtrl setGreenNavigationBar];
        }];
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [sortArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StoreListCell *cell = (StoreListCell*)[cv dequeueReusableCellWithReuseIdentifier:StoreListCell_NIB forIndexPath:indexPath];
    
    BookModel *item = sortArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
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
        return CGSizeMake(150, 275);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return [Utility isPad] ? UIEdgeInsetsMake(20, 20, 20, 20) :[Utility isLessPhone5] ? UIEdgeInsetsMake(0, 0, 1, 1) : UIEdgeInsetsMake(0, 0, 1, 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self delegate]) {
        [[self delegate] storeListSelectBook:sortArray[indexPath.row]];
    }
}

#pragma mark - request book

-(void)requestListBook{
    [self showProgressLoading];
    NSURLSessionTask *task = [KKBookService listAllBookService:^(NSArray *array, NSError *error) {
        [self dismissProgress];
        if (!error) {
            _myBook = [[NSMutableArray alloc] initWithArray:array];
            sortArray = [[NSMutableArray alloc] initWithArray:_myBook];
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
            //[self addButtonNavigation];
            for (CategoryModel *category in array) {
                [categories addObject:category];
            }
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

@end
