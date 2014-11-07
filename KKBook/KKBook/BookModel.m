//
//  Book.m
//  KKBooK
//
//  Created by PromptNow on 11/4/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

-(instancetype)initWithAttributes:(NSDictionary *)attribute
{
    self = [super init];
    if (self) {
        self.bookID = [attribute objectForKey:@"BookID"];
        self.bookName = [attribute objectForKey:@"BookName"];
        self.bookDesc = [attribute objectForKey:@"BookDesc"];
        self.bookDate = [attribute objectForKey:@"BookDate"];
        self.authorID = [attribute objectForKey:@"AuthorID"];
        self.authorName = [attribute objectForKey:@"AuthorName"];
        self.coverPrice = [attribute objectForKey:@"CoverPrice"];
        self.editDate = [attribute objectForKey:@"EditDate"];
        self.editUser = [attribute objectForKey:@"EditUser"];
        self.fileAndroidPhoneURL = [attribute objectForKey:@"FileAndroidTabURL"];
        self.fileAndroidTabURL = [attribute objectForKey:@"FileAndroidTabURL"];
        self.filePadURL = [attribute objectForKey:@"FilePadURL"];
        self.filePhoneURL = [attribute objectForKey:@"FilePhoneURL"];
        self.fileSizeAndroidPhoneURL = [attribute objectForKey:@"FileSizeAndroidPhoneURL"];
        self.fileSizeAndroidTabURL = [attribute objectForKey:@"FileSizeAndroidTabURL"];
        self.fileSizePadURL = [attribute objectForKey:@"FileSizePadURL"];
        self.fileSizePhoneURL = [attribute objectForKey:@"FileSizePhoneURL"];
        self.fileTypeID = [attribute objectForKey:@"FileTypeID"];
        self.fileTypeName = [attribute objectForKey:@"FileTypeName"];
        self.free = [attribute objectForKey:@"Free"];
        self.issn = [attribute objectForKey:@"ISSN"];
        self.onSaleDate = [attribute objectForKey:@"OnSaleDate"];
        self.padImageURL = [attribute objectForKey:@"PadImageURL"];
        self.phoneImageURL = [attribute objectForKey:@"PhoneImageURL"];
        self.padImageHDURL = [attribute objectForKey:@"PadImageHDURL"];
        self.phoneImageHDURL = [attribute objectForKey:@"PhoneImageHDURL"];
        self.price = [attribute objectForKey:@"Price"];
        self.publisherID = [attribute objectForKey:@"PublisherID"];
        self.publisherName = [attribute objectForKey:@"PublisherName"];
        self.version = [attribute objectForKey:@"Version"];
    }
    return self;
}

-(BOOL)isFree{
    if ([_free isEqualToString:@"Y"]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - display value

-(NSString *)fileSizeDisplay{
    NSString *size = [Utility isPad] ? _fileSizePadURL : _fileSizePhoneURL;
    return size;
}

-(float)versionPackage{
    float version = [_version floatValue];
    return version;
}

-(NSString *)priceDisplay{
    NSString *price = [self isFree] ? @"FREE" : _price;
    return price;
}

-(NSString *)publisherDisplay{
    NSString *publisher = [_publisherName isEqualToString:@""] ? @"-" : _publisherName;
    return publisher;
}

-(NSString *)authorDisplay{
    return [_authorName isEqualToString:@""] ? @"-" : _authorName;
}

-(NSURL *)coverImageDetailBookURL{
    NSURL *url = [NSURL URLWithString:[IMAGE_URL stringByAppendingString:_padImageURL]];
    return url;
}

-(NSURL *)coverImageURL{
    NSURL *url = [NSURL URLWithString:[IMAGE_URL stringByAppendingString:[Utility isPad] ? _padImageURL : _phoneImageURL]];
    return url;
}

@end
