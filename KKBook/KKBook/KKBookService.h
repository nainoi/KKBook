//
//  KKBookService.h
//  KKBooK
//
//  Created by PromptNow on 11/3/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKBookService : NSObject

+ (NSURLSessionDataTask *)listAllBookService:(void (^)(NSArray *posts, NSError *error))block;
+ (NSURLSessionDataTask *)previewBookService:(void (^)(NSArray *posts, NSError *error))block;

@end
