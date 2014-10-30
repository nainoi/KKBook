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
    
    PSCollectionViewCell *cell = (PSCollectionViewCell *)[collectionView dequeueReusableViewForClass:[PSCollectionViewCell class]];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MCCollectionViewCell" owner:self options:nil];
        cell = (MCCollectionViewCell *)[nib objectAtIndex:0];
    }
    
    NSOperationQueue *imageQueue = [[NSOperationQueue alloc] init];
    [imageQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        int r = arc4random() % 3;
        NSString *imageName = [NSString stringWithFormat:@"image%d", r];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"]];
        
        [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
            cell.previewImageView.image = image;
            cell.titleLabel.text = imageName;
        }]];
    }]];
    
    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    return 0.0;
}

@end
