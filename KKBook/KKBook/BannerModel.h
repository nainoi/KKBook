//
//  BannerModel.h
//  KKBooK
//
//  Created by PromptNow on 11/5/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property(copy, nonatomic) NSString *bannerName;
@property(copy, nonatomic) NSString *bannerURL;
@property(copy, nonatomic) NSString *bannerImage;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
