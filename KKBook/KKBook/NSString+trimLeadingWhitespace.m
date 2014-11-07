//
//  NSString+trimLeadingWhitespace.m
//  SuperBowl
//
//  Created by Yothin Samrandee on 4/2/56 BE.
//  Copyright (c) 2556 Digix Technology Co.,Ltd. All rights reserved.
//

#import "NSString+trimLeadingWhitespace.h"

@implementation NSString (trimLeadingWhitespace)

-(NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    
    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

@end
