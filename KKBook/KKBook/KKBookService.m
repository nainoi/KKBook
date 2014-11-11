//
//  KKBookService.m
//  KKBooK
//
//  Created by PromptNow on 11/3/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookService.h"
#import "AFNetworking.h"
#import "AFAppDotNetAPIClient.h"
#import "BookModel.h"

@implementation KKBookService

#pragma mark - book store service

+ (NSURLSessionDataTask *)listAllBookService:(void (^)(NSArray *, NSError *))block {
    return [[AFAppDotNetAPIClient sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            BookModel *post = [[BookModel alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+ (NSURLSessionDataTask *)previewBookService:(void (^)(NSArray *, NSError *))block{
    return [[AFAppDotNetAPIClient sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        NSLog(@"json %@",JSON);
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            BookModel *post = [[BookModel alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+(NSURLSessionDataTask *)storeMainService:(void (^)(NSArray *, NSError *))block{
    NSMutableDictionary *params = [KKBookService paramsLog];
    [params setObject:FLAG_TEST forKey:@"TestFlag"];
    return [[AFAppDotNetAPIClient sharedClient] POST:STORE_MAIN_URL parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"json %@",JSON);
        NSArray *postsFromResponse = JSON;
        if (block) {
            block([NSArray arrayWithArray:postsFromResponse], nil);
        }

    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

#pragma mark - Load File

+(void)downloadFileWithURL{
    NSURL *url = [NSURL URLWithString:@"http://www.raywenderlich.com/wp-content/uploads/2014/01/sunny-background.png"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //self.backgroundImageView.image = responseObject;
//        [self saveImage:responseObject withFilename:@"background.png"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}

+(NSMutableDictionary*)paramsLog{
    
    NSString *osVersion = [UIDevice currentDevice].systemVersion;
    
    //--- Machine
    //NSString *_machine = [[UIDevice currentDevice] platformString];
    
    //--- UDID
    //NSString *uid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    
    //--- Version
    //NSString *version = [AppHelper appVersion];
    
    //--- Country
    NSLocale *currentUsersLocale = [NSLocale currentLocale];
    NSString *currentLocaleID = [currentUsersLocale localeIdentifier];
    
    //--- Language
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    //--- carrier
    //NSString *carrier = [AppLogger carrier];
    
    //--- ip
//    NSString *ip = [UIDevice localWiFiIPAddress];
//    if (nil == ip) {
//        ip = [UIDevice localCellularIPAddress];
//    }
//    if (ip == nil) {
//        ip = @"";
//    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:osVersion forKey:@"VersionOS"];
    [params setObject:[Utility platform] forKey:@"Machine"];
    //[params setObject:uid forKey:@"UDID"];
    //[params setObject:version forKey:@"VersionApp"];
    [params setObject:currentLocaleID forKey:@"CurrentLocaleID"];
    [params setObject:currentLanguage forKey:@"Language"];
    //[params setObject:carrier forKey:@"Network"];
    //[params setObject:ip forKey:@"IPAddress"];
    [params setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"ApplicationID"];
    [params setObject:[Utility isPad]?@"pd":@"pn" forKey:@"platform"];
    
    return params;
}


@end
