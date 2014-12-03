//
//  KKBookStoreListVC.h
//  KKBooK
//
//  Created by PromptNow on 11/11/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookModel;

@protocol KKBookStoreListDelegate <NSObject>

-(void)storeListSelectBook:(BookModel*)bookModel;

@end

@interface KKBookStoreListVC : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) UIPopoverController *popoverViewController;
@property(nonatomic, strong) NSMutableArray *myBook;
@property(nonatomic, assign) id<KKBookStoreListDelegate>delegate;

@end
