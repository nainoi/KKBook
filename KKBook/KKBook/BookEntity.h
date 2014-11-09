//
//  BookEntity.h
//  KKBooK
//
//  Created by PromptNow on 11/9/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "BookModel.h"

@interface BookEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * bookID;
@property (nonatomic, retain) NSString * bookName;
@property (nonatomic, retain) NSString * bookDate;
@property (nonatomic, retain) NSNumber * fileTypeID;
@property (nonatomic, retain) NSString * fileTypeName;
@property (nonatomic, retain) NSString * bookDesc;
@property (nonatomic, retain) NSNumber * publisherID;
@property (nonatomic, retain) NSString * publisherName;
@property (nonatomic, retain) NSNumber * authorID;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * coverPrice;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSString * issn;
@property (nonatomic, retain) NSString * onSaleDate;
@property (nonatomic, retain) NSNumber * languageID;
@property (nonatomic, retain) NSNumber * enableFlag;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * fileUrl;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSNumber * free;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * editdate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * coverName;
@property (nonatomic, retain) NSString * folder;
@property (nonatomic, retain) NSDate * dateAdd;

@end
