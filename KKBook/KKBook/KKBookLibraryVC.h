//
//  KKBookLibraryVC.h
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKBookLibraryVC : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end
