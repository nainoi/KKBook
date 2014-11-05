//
//  BannerModel.m
//  KKBooK
//
//  Created by PromptNow on 11/5/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.bannerImage = dict[@""];
        self.bannerName = dict[@""];
        self.bannerURL = dict[@""];
    }
    return self;
}

@end
