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
    return [[AFAppDotNetAPIClient sharedClient] POST:STORE_MAIN_URL parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
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
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"....zip"]];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"....zip"];
//    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Successfully downloaded file to %@", path);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
//        NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
//        NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
//        NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
//        NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
//        NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
//    }];
//    [operations addObject:operation];
}

@end
