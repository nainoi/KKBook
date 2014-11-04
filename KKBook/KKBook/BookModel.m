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

-(float)fileSizePad{
    float size = [_filePadURL floatValue];
    return size;
}

-(float)fileSizePhone{
    float size = [_filePhoneURL floatValue];
    return size;
}

-(float)versionPackage{
    float size = [_version floatValue];
    return size;
}

@end
