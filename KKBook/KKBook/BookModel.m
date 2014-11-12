//
//  Book.m
//  KKBooK
//
//  Created by PromptNow on 11/4/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "BookModel.h"
#import "FormValidation.h"
#import "FileHelper.h"

@implementation BookModel

-(instancetype)initWithAttributes:(NSDictionary *)attribute
{
    self = [super init];
    if (self) {
        self.bookID = [FormValidation stringValue:[attribute objectForKey:@"BookID"]];
        self.bookName = [FormValidation stringValue:[attribute objectForKey:@"BookName"]];
        self.bookDesc = [FormValidation stringValue:[attribute objectForKey:@"BookDesc"]];
        self.bookDate = [FormValidation stringValue:[attribute objectForKey:@"BookDate"]];
        self.authorID = [FormValidation stringValue:[attribute objectForKey:@"AuthorID"]];
        self.authorName = [FormValidation stringValue:[attribute objectForKey:@"AuthorName"]];
        self.categoryID = [FormValidation stringValue:[attribute objectForKey:@"CategoryID"]];
        self.categoryName = [FormValidation stringValue:[attribute objectForKey:@"CategoryName"]];
        self.coverPrice = [FormValidation stringValue:[attribute objectForKey:@"CoverPrice"]];
        self.page = [FormValidation stringValue:[attribute objectForKey:@"Page"]];
        self.editDate = [FormValidation stringValue:[attribute objectForKey:@"EditDate"]];
        self.editUser = [FormValidation stringValue:[attribute objectForKey:@"EditUser"]];
        self.fileAndroidPhoneURL = [FormValidation stringValue:[attribute objectForKey:@"FileAndroidTabURL"]];
        self.fileAndroidTabURL = [FormValidation stringValue:[attribute objectForKey:@"FileAndroidTabURL"]];
        self.filePadURL = [FormValidation stringValue:[attribute objectForKey:@"FilePadURL"]];
        self.filePhoneURL = [FormValidation stringValue:[attribute objectForKey:@"FilePhoneURL"]];
        self.fileSizeAndroidPhoneURL = [FormValidation stringValue:[attribute objectForKey:@"FileSizeAndroidPhoneURL"]];
        self.fileSizeAndroidTabURL = [FormValidation stringValue:[attribute objectForKey:@"FileSizeAndroidTabURL"]];
        self.fileSizePadURL = [FormValidation stringValue:[attribute objectForKey:@"FileSizePadURL"]];
        self.fileSizePhoneURL = [FormValidation stringValue:[attribute objectForKey:@"FileSizePhoneURL"]];
        self.fileTypeID = [FormValidation stringValue:[attribute objectForKey:@"FileTypeID"]];
        self.fileTypeName = [FormValidation stringValue:[attribute objectForKey:@"FileTypeName"]];
        self.free = [FormValidation stringValue:[attribute objectForKey:@"Free"]];
        self.issn = [FormValidation stringValue:[attribute objectForKey:@"ISSN"]];
        self.onSaleDate = [FormValidation stringValue:[attribute objectForKey:@"OnSaleDate"]];
        self.padImageURL = [FormValidation stringValue:[attribute objectForKey:@"PadImageURL"]];
        self.phoneImageURL = [FormValidation stringValue:[attribute objectForKey:@"PhoneImageURL"]];
        self.padImageHDURL = [FormValidation stringValue:[attribute objectForKey:@"PadImageHDURL"]];
        self.phoneImageHDURL = [FormValidation stringValue:[attribute objectForKey:@"PhoneImageHDURL"]];
        self.price = [FormValidation stringValue:[attribute objectForKey:@"Price"]];
        self.publisherID = [FormValidation stringValue:[attribute objectForKey:@"PublisherID"]];
        self.publisherName = [FormValidation stringValue:[attribute objectForKey:@"PublisherName"]];
        self.version = [FormValidation stringValue:[attribute objectForKey:@"Version"]];
        self.status = DOWNLOADWAITING;
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
    float file = [Utility isPad] ? [_fileSizePadURL floatValue] : [_fileSizePhoneURL floatValue];
    float fileSize =  file/(1024.0f*1024.0f);
    NSString *size = [NSString stringWithFormat:@"%.2f MB",fileSize];
    return size;
}

-(float)versionPackage{
    float version = [_version floatValue];
    return version;
}

-(NSString *)priceDisplay{
    NSString *price = [self isFree] ? @"FREE" : [[NSString stringWithCurrencyformat:_price] stringByAppendingString:@" $"];
    return price;
}

-(NSString *)publisherDisplay{
    NSString *publisher = [_publisherName isEqualToString:@""] ? @"-" : _publisherName;
    return publisher;
}

-(NSString *)authorDisplay{
    return [_authorName isEqualToString:@""] ? @"-" : _authorName;
}

-(NSString *)coverImageDetailBookURL{
    return [IMAGE_URL stringByAppendingString:_padImageURL];
}

-(NSString *)coverImageURL{
    NSString *stringURL;
    if ([Utility isPad]) {
        if ([Utility isRetina]) {
            stringURL = [IMAGE_URL stringByAppendingString:_padImageHDURL];
        }else{
            stringURL = [IMAGE_URL stringByAppendingString:_padImageURL];
        }
    }else{
        if ([Utility isRetina]) {
            stringURL = [IMAGE_URL stringByAppendingString:_phoneImageHDURL];
        }else{
            stringURL = [IMAGE_URL stringByAppendingString:_phoneImageURL];
        }
    }
    return stringURL;
}

-(NSString *)fileURL{
    NSString *stringURL;
    if ([Utility isPad]) {
        stringURL = [BOOK_URL stringByAppendingString:_filePadURL];
    }else{
        stringURL = [BOOK_URL stringByAppendingString:_filePhoneURL];
    }
    return stringURL;

}

@end
