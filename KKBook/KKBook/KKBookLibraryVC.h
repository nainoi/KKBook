//
//  KKBookLibraryVC.h
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKBookLibraryVC;
@class BookEntity;

@protocol KKBookLibraryDelegate <NSObject>

-(void)didSelectBook:(KKBookLibraryVC*)bookLibrary withBookEntity:(BookEntity*)bookEntity;

@end

@interface KKBookLibraryVC : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *myBook;
@property(nonatomic, assign) BOOL isDelete;
@property(nonatomic, assign) id<KKBookLibraryDelegate> delegate;

@end
