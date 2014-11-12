//
//  Book.h
//  KKBooK
//
//  Created by PromptNow on 11/4/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

// server value
@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, copy) NSString *bookDate;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *fileTypeID;
@property (nonatomic, copy) NSString *fileTypeName;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *bookDesc;
@property (nonatomic, copy) NSString *publisherID;
@property (nonatomic, copy) NSString *publisherName;
@property (nonatomic, copy) NSString *authorID;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *coverPrice;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *issn;
@property (nonatomic, copy) NSString *onSaleDate;
@property (nonatomic, copy) NSString *languageID;
@property (nonatomic, copy) NSString *enableFlag;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *phoneImageURL;
@property (nonatomic, copy) NSString *phoneImageHDURL;
@property (nonatomic, copy) NSString *padImageURL;
@property (nonatomic, copy) NSString *padImageHDURL;
@property (nonatomic, copy) NSString *filePhoneURL;
@property (nonatomic, copy) NSString *filePadURL;
@property (nonatomic, copy) NSString *fileAndroidPhoneURL;
@property (nonatomic, copy) NSString *fileAndroidTabURL;
@property (nonatomic, copy) NSString *fileSizePhoneURL;
@property (nonatomic, copy) NSString *fileSizePadURL;
@property (nonatomic, copy) NSString *fileSizeAndroidPhoneURL;
@property (nonatomic, copy) NSString *fileSizeAndroidTabURL;
@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *editDate;
@property (nonatomic, copy) NSString *editUser;

// class value

@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, copy) NSString *fileSizeDisplay;
@property (nonatomic, copy) NSString *priceDisplay;
@property (nonatomic, assign) float versionPackage;
@property (nonatomic, copy) NSString *publisherDisplay;
@property (nonatomic, copy) NSString *authorDisplay;
@property (nonatomic, copy) NSString *coverImageURL;
@property (nonatomic, copy) NSString *coverImageDetailBookURL;
@property (nonatomic, copy) NSString *fileURL;
@property (nonatomic, copy) NSString *status;

-(instancetype)initWithAttributes:(NSDictionary*)attribute;

@end
