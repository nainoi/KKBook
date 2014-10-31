//
//  KKBookStoreVC.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 29/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookStoreVC.h"

#import "PSCollectionView.h"

@interface KKBookStoreVC ()<PSCollectionViewDataSource, PSCollectionViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PSCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *books;

@end

@implementation KKBookStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - init

-(void)initVIew{
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectZero];
    self.collectionView.delegate = self; // This is for UIScrollViewDelegate
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = ~UIViewAutoresizingNone;
    
    // Specify number of columns for both iPhone and iPad
    if ([Utility isPad]) {
        self.collectionView.numColsPortrait = 3;
        self.collectionView.numColsLandscape = 4;
    } else {
        self.collectionView.numColsPortrait = 1;
        self.collectionView.numColsLandscape = 2;
    }
}

#pragma mark - PSCollection datasource and delegate

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [PSCollectionViewCell class];
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return 0;
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    
    NSDictionary *book = [self.books objectAtIndex:index];
    // You should probably subclass PSCollectionViewCell
    PSCollectionViewCell *v = (PSCollectionViewCell *)[collectionView dequeueReusableViewForClass:[PSCollectionViewCell class]];
    if (!v) {
        v = [[PSCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    
    [v fillViewWithObject:book]
    
    return v;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    return 0.0;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.books objectAtIndex:index];
    
    // You should probably subclass PSCollectionViewCell
    return [PSCollectionViewCell heightForViewWithObject:item inColumnWidth:self.collectionView.colWidth];
}

@end
