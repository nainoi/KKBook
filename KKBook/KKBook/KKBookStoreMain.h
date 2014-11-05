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

@interface KKBookStoreMain : UIViewController<HGPageScrollViewDelegate, HGPageScrollViewDataSource, UITextFieldDelegate> {
    
    HGPageScrollView *_myPageScrollView;
    NSMutableArray   *_myPageDataArray;
    
    NSMutableIndexSet *indexesToDelete, *indexesToInsert, *indexesToReload;
}



@end
