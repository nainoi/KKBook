//
//  DataManager.h
//  KKBooK
//
//  Created by PromptNow on 11/9/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookModel.h"
#import "BookEntity.h"

@class AFHTTPRequestOperation;

@interface DataManager : NSObject

+(instancetype)shareInstance;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSMutableArray *responceArray;

-(NSArray*)selectAllMyBook;
-(void)insertBookWithBookModel:(BookModel*)bookModel onComplete:(void (^)(NSArray *))completionBlock;
-(void)deleteBookWithBookID:(BookEntity *)bookEntity onComplete:(void (^)(NSArray *))completionBlock;
-(BookEntity*)selectBookFromBookID:(NSString*)bookID;

-(void)downloadBook:(BookEntity*)bookEntity onComplete:(void (^)(NSString *))downloadStatus;
-(AFHTTPRequestOperation*)selectResponseOperationWithBookEntity:(BookEntity*)bookEntity;
-(BOOL)isHasBookFormBookID:(NSString *)bookID;

@end
