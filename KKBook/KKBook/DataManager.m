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
#import "AESCrypt.h"
#import "NSData+CommonCrypto.h"
#import "AFDownloadRequestOperation.h"

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

-(NSMutableArray *)responceArray{
    if (!_responceArray) {
        self.responceArray = [[NSMutableArray alloc] init];
    }
    return _responceArray;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:BookDidStart object:nil];
    [self downloadImageCover:bookEntity.imageUrl onComplete:^(NSString *imagePath){
        //[self performSelector:@selector(downloadBook:onComplete:) withObject:bookEntity afterDelay:0.75];
        [self downloadBook:bookEntity onComplete:^(NSString *status){
            if (completionBlock) {
                completionBlock([self selectAllMyBook]);
            }
        }];
    }];
}

-(void)deleteBookWithBookID:(BookEntity *)bookEntity onComplete:(void (^)(NSArray *))completionBlock{
    NSString *folder = [[FileHelper booksPath] stringByAppendingPathComponent:bookEntity.folder];
    if ([folder isEqualToString:[FileHelper booksPath]]) {
        JLLog( @"Book folder is invalid:%@",folder);
    }
    
    [[self managedObjectContext] deleteObject:bookEntity];

    NSError *error;
    
    if([[self managedObjectContext] save:&error]){
        
        NSString *dlTempPath = [folder stringByAppendingPathExtension:@"tmp"];
        if ([FileHelper fileExists:dlTempPath isDir:NO]) {
            [FileHelper removeAtPath:dlTempPath];
        }
        
        NSLog(@"Delete complete:%@",[folder lastPathComponent]);
        if (![folder isEqualToString:[FileHelper booksPath]]){
            [FileHelper removeDirAtPath:folder];
        }
        
        if (completionBlock) {
            completionBlock([self selectAllMyBook]);
        }
    }else{
        
    }
}

-(BookEntity *)selectBookFromBookID:(NSString *)bookID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookEntity"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookID == %@",[NSNumber numberWithInteger:[bookID integerValue]]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        return [fetchedObjects lastObject];
    }
    return nil;
}

-(BOOL)isHasBookFormBookID:(NSString *)bookID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookEntity"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookID == %@",[NSNumber numberWithInteger:[bookID integerValue]]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        return YES;
    }
    return NO;
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
    /*JLLog(@"Load book from url : %@",bookEntity.fileUrl);
    NSURL *url = [NSURL URLWithString:bookEntity.fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    if (![FileHelper fileExists:[[FileHelper booksPath]stringByAppendingPathComponent:bookEntity.folder] isDir:YES]){
        if([FileHelper createAtPath:[[FileHelper booksPath]stringByAppendingPathComponent:bookEntity.folder]])
            NSLog(@"create folder %@",bookEntity.folder);
    }

    
    NSString *path = [[FileHelper booksPath] stringByAppendingPathComponent:[bookEntity.folder stringByAppendingPathComponent:[ bookEntity.fileUrl lastPathComponent]]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    operation.userInfo = [NSDictionary dictionaryWithObject:bookEntity forKey:KKBOOK_KEY];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        //NSString *extractFile = [[[[FileHelper booksPath] stringByAppendingPathComponent:bookEntity.folder]stringByAppendingPathComponent:bookEntity.folder]stringByAppendingPathExtension:@"pdf"];
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
            for (AFHTTPRequestOperation *oper in self.responceArray) {
                if (oper == operation) {
                    [self.responceArray removeObject:operation];
                }
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (downloadStatus) {
            downloadStatus(DOWNLOADFAIL);
        }
        bookEntity.status = DOWNLOADFAIL;
        [self saveBookEntity:bookEntity];
        [[NSNotificationCenter defaultCenter] postNotificationName:BookDidFail object:operation];
        [self.responceArray removeObject:operation];
        [self.responceArray addObject:operation];
    }];
    
    bookEntity.status = DOWNLOADING;
    [self saveBookEntity:bookEntity];
    [operation start];
    if (downloadStatus) {
        downloadStatus(DOWNLOADING);
    }
    [self.responceArray addObject:operation];
    //[[NSNotificationCenter defaultCenter] postNotificationName:BookDidResponce object:operation];*/
    NSString *path = [[FileHelper booksPath] stringByAppendingPathComponent:[bookEntity.folder stringByAppendingPathComponent:[ bookEntity.fileUrl lastPathComponent]]];

    NSURL *url = [NSURL URLWithString:bookEntity.fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block AFHTTPRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    
    if (![FileHelper fileExists:[[FileHelper booksPath]stringByAppendingPathComponent:bookEntity.folder] isDir:YES]){
        if([FileHelper createAtPath:[[FileHelper booksPath]stringByAppendingPathComponent:bookEntity.folder]])
            NSLog(@"create folder %@",bookEntity.folder);
    }
    
    
//    NSString *path = [[FileHelper booksPath] stringByAppendingPathComponent:[bookEntity.folder stringByAppendingPathComponent:[ bookEntity.fileUrl lastPathComponent]]];
//    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    operation.userInfo = [NSDictionary dictionaryWithObject:bookEntity forKey:KKBOOK_KEY];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        //NSString *extractFile = [[[[FileHelper booksPath] stringByAppendingPathComponent:bookEntity.folder]stringByAppendingPathComponent:bookEntity.folder]stringByAppendingPathExtension:@"pdf"];
        NSString *folderPath = [[FileHelper booksPath] stringByAppendingPathComponent:bookEntity.folder];
        if ([FileHelper extractFile:path outputPath:folderPath]) {
            //DELETE OLD FILE
            if (![FileHelper removeAtPath:path]) {
                //
            }
            NSArray *files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:folderPath error:nil];
            for(NSString* file in files){
                if ([[file pathExtension]isEqualToString:@"pdf"]||[[file pathExtension] isEqualToString:@"PDF"]) {
                    NSData *data = [NSData dataWithContentsOfFile:[folderPath stringByAppendingPathComponent:file]];
                    NSError *error;
                    NSData *dataEncrypt = [data AES256EncryptedDataUsingKey:PASSWORD_ENCRYPT error:&error];
                    if(![dataEncrypt writeToFile:[folderPath stringByAppendingPathComponent:file] options:NSDataWritingAtomic error:&error])
                        NSLog(@"Write returned error: %@", [error localizedDescription]);
                    
                }
            }
            if (downloadStatus) {
                downloadStatus(DOWNLOADCOMPLETE);
            }
            bookEntity.status = DOWNLOADCOMPLETE;
            [self saveBookEntity:bookEntity];
            [[NSNotificationCenter defaultCenter] postNotificationName:BookDidFinish object:operation];
            for (AFHTTPRequestOperation *oper in self.responceArray) {
                if (oper == operation) {
                    [self.responceArray removeObject:operation];
                }
            }
        }else{
            if (downloadStatus) {
                downloadStatus(DOWNLOADFAIL);
            }
            bookEntity.status = DOWNLOADFAIL;
            [self saveBookEntity:bookEntity];
            [[NSNotificationCenter defaultCenter] postNotificationName:BookDidFail object:operation];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (downloadStatus) {
            downloadStatus(DOWNLOADFAIL);
        }
        bookEntity.status = DOWNLOADFAIL;
        [self saveBookEntity:bookEntity];
        [[NSNotificationCenter defaultCenter] postNotificationName:BookDidFail object:operation];
//        [self.responceArray removeObject:operation];
//        [self.responceArray addObject:operation];
    }];
    
    bookEntity.status = DOWNLOADING;
    [self saveBookEntity:bookEntity];
    [operation start];
    if (downloadStatus) {
        downloadStatus(DOWNLOADING);
    }
    [self.responceArray addObject:operation];
    [[NSNotificationCenter defaultCenter] postNotificationName:BookDidResponce object:operation];
    
    
    
    
//    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
//        // do something here.
//    }];
}

-(AFHTTPRequestOperation*)selectResponseOperationWithBookEntity:(BookEntity*)bookEntity{
    for (AFHTTPRequestOperation *operation in self.responceArray) {
        BookEntity *book = (BookEntity*)[operation.userInfo objectForKey:KKBOOK_KEY];
        NSLog(@"id = %@, id = %@",bookEntity.bookID, book.bookID);
        if ([book.bookID isEqualToNumber:bookEntity.bookID]) {
            return operation;
        }
    }
    return nil;
}

@end
