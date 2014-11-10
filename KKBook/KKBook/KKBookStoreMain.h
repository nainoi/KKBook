//
//  KKBookStorList.h
//  KKBooK
//
//  Created by PromptNow on 11/4/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPageScrollView.h"
#import "HGPageImageView.h"

@class KKBookStoreMain;
@class BookModel;

@protocol KKBookStoreMainDelegate <NSObject>

-(void)bookStoreMain:(KKBookStoreMain*)storeMain didBook:(BookModel*)book;
-(void)bookStoreMain:(KKBookStoreMain *)storeMain didListBook:(BookModel *)book;

@end

@interface KKBookStoreMain : BaseViewController<HGPageScrollViewDelegate, HGPageScrollViewDataSource, UITextFieldDelegate> {
    
    HGPageScrollView *_myPageScrollView;
    NSMutableArray   *_myPageDataArray;
    
    NSMutableIndexSet *indexesToDelete, *indexesToInsert, *indexesToReload;
}

@property(assign, nonatomic) id<KKBookStoreMainDelegate> delegate;
@property (retain, nonatomic) NSTimer *timer;

@end
