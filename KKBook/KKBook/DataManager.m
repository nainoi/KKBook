//
//  DataManager.m
//  KKBooK
//
//  Created by PromptNow on 11/9/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "FileHelper.h"

@implementation DataManager

+(instancetype)shareInstance{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static DataManager *_sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [appDelegate managedObjectContext];
}

-(void)saveBookEntity:(BookEntity*)bookEntity{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}

-(void)insertBookWithBookModel:(BookModel *)bookModel onComplete:(void (^)(NSArray *))completionBlock{
    NSManagedObjectContext *context = [self managedObjectContext];
    BookEntity *bookEntity = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"BookEntity"
                                      inManagedObjectContext:context];
    bookEntity.bookID = [NSNumber numberWithInt:[bookModel.bookID intValue]];
    bookEntity.bookName = bookModel.bookName;
    bookEntity.bookDate = bookModel.bookDate;
    bookEntity.bookDesc = bookModel.bookDesc;
    bookEntity.fileTypeID = [NSNumber numberWithInt:[bookModel.fileTypeID intValue]];
    bookEntity.fileTypeName = bookModel.fileTypeName;
    bookEntity.fileUrl = bookModel.fileURL;
    bookEntity.fileSize = [NSNumber numberWithInt:[bookModel.fileSize intValue]];
    bookEntity.publisherID = [NSNumber numberWithInt:[bookModel.publisherID intValue]];
    bookEntity.publisherName = bookModel.publisherName;
    bookEntity.authorID = [NSNumber numberWithInt:[bookModel.authorID intValue]];
    bookEntity.authorName = bookModel.authorName;
    bookEntity.price = [NSNumber numberWithFloat:[bookModel.price floatValue]];
    bookEntity.page = [NSNumber numberWithInt:[bookModel.page intValue]];
    bookEntity.issn = bookModel.issn;
    bookEntity.onSaleDate = bookModel.onSaleDate;
    bookEntity.languageID = [NSNumber numberWithInt:[bookModel.languageID intValue]];
    bookEntity.enableFlag = [NSNumber numberWithBool:YES];
    bookEntity.free = [NSNumber numberWithBool:bookModel.isFree];
    bookEntity.version = [NSNumber numberWithFloat:[bookModel.version floatValue]];
    bookEntity.imageUrl = bookModel.coverImageURL;
    bookEntity.status = bookModel.status;
    bookEntity.dateAdd = [NSDate date];
    bookEntity.coverName = [bookModel.coverImageURL lastPathComponent];
    bookEntity.folder = [[bookModel.fileURL lastPathComponent] stringByDeletingPathExtension];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self downloadImageCover:bookEntity.imageUrl onComplete:^(NSString *imagePath){
        [self downloadBook:bookEntity onComplete:^(NSString *status){
            if (completionBlock) {
                completionBlock([self selectAllMyBook]);
            }
        }];
    }];
}

-(void)deleteBookWithBookID:(NSString *)bookID onComplete:(void (^)(NSArray *))completionBlock{

}

-(BookEntity *)selectBookFromBookID:(NSString *)bookID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookEntity"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        return [fetchedObjects lastObject];
    }
    return nil;
}

-(NSArray*)selectAllMyBook{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookEntity"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    JLLog(@"my book count %lu ",(unsigned long)fetchedObjects.count);
    return fetchedObjects;
}


#pragma mark - File Download

-(void)downloadImageCover:(NSString*)imageUrl onComplete:(void (^)(NSString *))completionBlock{
    JLLog(@"Load image from url : %@",imageUrl);
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *path = [[FileHelper coversPath] stringByAppendingPathComponent:[imageUrl lastPathComponent]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    JLLog(@"image path : %@",path);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        if (completionBlock) {
            completionBlock(path);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];

}

-(void)downloadBook:(BookEntity*)bookEntity onComplete:(void (^)(NSString *))downloadStatus{
    JLLog(@"Load book from url : %@",bookEntity.fileUrl);
    NSURL *url = [NSURL URLWithString:bookEntity.fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    if (![FileHelper fileExists:[[FileHelper booksPath]stringByAppendingPathComponent:bookEntity.folder] isDir:YES]){
        if([FileHelper createAtPath:[[FileHelper booksPath]stringByAppendingPathComponent:bookEntity.folder]])
            NSLog(@"create folder %@",bookEntity.folder);
    }

    
    NSString *path = [[FileHelper booksPath] stringByAppendingPathComponent:[bookEntity.folder stringByAppendingPathComponent:[ bookEntity.fileUrl lastPathComponent]]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    operation.userInfo = [NSDictionary dictionaryWithObject:bookEntity forKey:KKBOOK_KEY];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        if ([FileHelper extractFile:path outputPath:[[FileHelper booksPath] stringByAppendingPathComponent:bookEntity.folder]]) {
            //DELETE OLD FILE
            if (![FileHelper removeAtPath:path]) {
                //
            }
            if (downloadStatus) {
                downloadStatus(DOWNLOADCOMPLETE);
            }
            bookEntity.status = DOWNLOADCOMPLETE;
            [self saveBookEntity:bookEntity];
            [[NSNotificationCenter defaultCenter] postNotificationName:BookDidFinish object:operation];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (downloadStatus) {
            downloadStatus(DOWNLOADFAIL);
        }
        bookEntity.status = DOWNLOADFAIL;
        [self saveBookEntity:bookEntity];
        [[NSNotificationCenter defaultCenter] postNotificationName:BookDidFail object:operation];
    }];
    
    bookEntity.status = DOWNLOADING;
    [self saveBookEntity:bookEntity];
    [[NSNotificationCenter defaultCenter] postNotificationName:BookDidStart object:operation];
    [operation start];
    if (downloadStatus) {
        downloadStatus(DOWNLOADING);
    }
    
    
}

@end
