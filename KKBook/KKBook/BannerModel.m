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
        self.bannerImage = [BANNER_PATH_URL stringByAppendingString:dict[[Utility isPad] ? @"TabletURL" : @"PhoneURL"]];
        self.bannerName = dict[@""];
        self.bannerURL = dict[@"Link"];
    }
    return self;
}

@end
