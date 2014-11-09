//
//  FormValidation.m
//  SuperBowl
//
//  Created by Yothin Samrandee on 4/2/56 BE.
//  Copyright (c) 2556 Digix Technology Co.,Ltd. All rights reserved.
//

#import "FormValidation.h"
#import "NSString+trimLeadingWhitespace.h"

@implementation FormValidation

#pragma -
#pragma Validate equal

+ (BOOL)validateEqual:(NSString*)value1 withValue2:(NSString*)value2{
    
    if([value1 isEqualToString:value2])return YES;
    return NO;
    
}


#pragma -
#pragma Validate empty

+ (BOOL)validateEmpty:(NSString*)value{
    
    NSString *trimed = [value stringByTrimmingLeadingWhitespace];
    if((nil == trimed) || ((NSNull*)value == [NSNull null]))return NO;
    if([trimed length]==0)return NO;
    return YES;
}


#pragma -
#pragma Validate email

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)boolValue:(id)obj{
    
    if (obj == nil) {
        return NO;
    }
    
    if ((NSNull*)obj == [NSNull null]) {
        return NO;
    }
    
    if (obj && [obj isKindOfClass:[NSString class]]) {
        if ([[obj lowercaseString] isEqualToString:@"yes"]) {
            return YES;
        }else if([[obj lowercaseString] isEqualToString:@"no"]){
            return NO;
        }
    }
    
    return [obj boolValue];
}

+ (NSString*)stringValue:(id)value{
    if(!value)return @"";
    
    if ((NSNull*)value == [NSNull null]) {
        return @"";
    }else if([value isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)value stringValue];
    }
    
    NSString *trimed = [(NSString*)value stringByTrimmingLeadingWhitespace];
    
    if([trimed length]==0)return @"";
    
    return value;
}

+(BOOL)phoneValid:(NSString *)p{
    NSString *phoneRegex = @"[0-9]{10}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [test evaluateWithObject:p];
}

@end
