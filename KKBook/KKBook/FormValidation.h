//
//  FormValidation.h
//  SuperBowl
//
//  Created by Yothin Samrandee on 4/2/56 BE.
//  Copyright (c) 2556 Digix Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormValidation : NSObject

+ (BOOL)validateEqual:(NSString*)value1 withValue2:(NSString*)value2;
+ (BOOL)validateEmpty:(NSString*)value;
+ (BOOL)validateEmailWithString:(NSString*)email;
+ (BOOL)boolValue:(id)obj;
+ (NSString*)stringValue:(id)obj;
+ (BOOL)phoneValid:(NSString*)p;

@end
