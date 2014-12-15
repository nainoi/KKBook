//
//  CategoryListTVC.h
//  KKBooK
//
//  Created by PromptNow on 11/28/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListTVC : UITableViewController

@property(nonatomic, strong) NSArray *categories;

@property(nonatomic, copy) void (^didSelectCategoryList)(NSString *categoryID, NSString *categoryName);

@end
