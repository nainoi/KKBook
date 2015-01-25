//
//  KKBookLibraryVC.m
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookLibraryVC.h"
#import "KKBookLibraryCell.h"
#import "DataManager.h"

@interface KKBookLibraryVC ()<KKBookLibraryCellDelegate, UIAlertViewDelegate>{
    NSInteger selectRow;
}

@end

@implementation KKBookLibraryVC

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.sectionInset = [Utility isPad] ? UIEdgeInsetsMake(20, 20, 20, 20) :[Utility isLessPhone5] ? UIEdgeInsetsMake(2, 2, 2, 2) : UIEdgeInsetsMake(5, 5, 5, 5);
        layout.minimumLineSpacing = [Utility isPad] ? 40 :[Utility isLessPhone5] ? 2 : 10;
        layout.minimumInteritemSpacing = [Utility isPad] ? 20 : [Utility isLessPhone5] ? 2 : 5 ;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
        //            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
        UINib *nib = [UINib nibWithNibName:LIBRARY_CELL bundle: nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:LIBRARY_CELL];
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.collectionView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    self.myBook = [[NSMutableArray alloc] initWithArray:[[DataManager shareInstance] selectAllMyBook]];
    
    [super viewDidLoad];
    [self removeNotification];
    [self addNotification];
    // Do any additional setup after loading the view from its nib.
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

-(void)addNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDownload:) name:BookDidStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responceDownload:) name:BookDidResponce object:nil];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidStart object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidResponce object:nil];
}

-(void)startDownload:(NSNotification*)noti{
    self.myBook = [[NSMutableArray alloc] initWithArray:[[DataManager shareInstance] selectAllMyBook]];
    [_collectionView reloadData];
}

-(void)responceDownload:(NSNotification*)noti
{
    [_collectionView reloadData];
}

-(void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    [_collectionView reloadData];
}
//-(void)setMyBook:(NSMutableArray *)myBook{
//    _myBook = myBook;
//    [_collectionView reloadData];
//}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [_myBook count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKBookLibraryCell *cell = (KKBookLibraryCell*)[cv dequeueReusableCellWithReuseIdentifier:LIBRARY_CELL forIndexPath:indexPath];
    
    BookEntity *item = _myBook[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    [cell setIsDelete:_isDelete];
    [cell setBookEntity:item];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [[UICollectionReusableView alloc] init];
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([Utility isPad]) {
        return CGSizeMake(130, 200);
    }else{
        
        return CGSizeMake(130, 200);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return [Utility isLessPhone5] ? UIEdgeInsetsMake(5, 15, 5, 15) : UIEdgeInsetsMake(5, 20, 5, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isDelete) {
        KKBookLibraryCell *cell = (KKBookLibraryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:LIBRARY_CELL forIndexPath:indexPath];
        cell = (KKBookLibraryCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if ([cell.bookEntity.status isEqualToString:DOWNLOADCOMPLETE]) {
            if ([self delegate]) {
                [[self delegate] didSelectBook:self withBookEntity:_myBook[indexPath.row]];
            }
        }else if ([cell.bookEntity.status isEqualToString:DOWNLOADFAIL]){
            [cell didResume:cell.resumeBtn];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"KKBook" message:@"Do you want to delete this book from device?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alertView show];
        selectRow = indexPath.row;
    }
}

#pragma mark - delegate

-(void)deleteBookOnLibrary:(KKBookLibraryCell *)cell withBookEntity:(BookEntity *)bookEntity{
    [[DataManager shareInstance] deleteBookWithBookID:bookEntity onComplete:^(NSArray *array){
        self.myBook = [[NSMutableArray alloc] initWithArray:[[DataManager shareInstance] selectAllMyBook]];
        if (_myBook.count == 0) {
            _isDelete = NO;
        }
        [_collectionView reloadData];
    }];
}

#pragma mark - delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[DataManager shareInstance] deleteBookWithBookID:_myBook[selectRow] onComplete:^(NSArray *array){
            self.myBook = [[NSMutableArray alloc] initWithArray:[[DataManager shareInstance] selectAllMyBook]];
            [_collectionView reloadData];
        }];
    }
}

@end
