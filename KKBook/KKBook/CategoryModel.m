//
//  CategoryModel.m
//  KKBooK
//
//  Created by PromptNow on 11/28/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.categoryID = [dict objectForKey:@"CategoryID"];
        self.categoryName = [dict objectForKey:@"CategoryName"];
    }
    return self;
}

@end
