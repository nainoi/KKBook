//
//  KKBookStoreVC.h
//  KKBooK
//
//  Created by PromptNow Ltd. on 29/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface KKBookStoreVC : BaseViewController<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end
