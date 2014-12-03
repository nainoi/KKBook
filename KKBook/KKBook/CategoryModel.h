//
//  CategoryModel.h
//  KKBooK
//
//  Created by PromptNow on 11/28/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property(copy, nonatomic) NSString *categoryID;
@property(nonatomic, copy) NSString *categoryName;

-(id)initWithDictionary:(NSDictionary*)dict;

@end
