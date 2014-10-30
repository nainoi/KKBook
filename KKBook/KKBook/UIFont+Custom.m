//
//  UIFont+Custom.m
//  SCBLife
//
//  Created by PromptNow on 10/10/2557 BE.
//  Copyright (c) 2557 Promptnow. All rights reserved.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+(UIFont *)fontRegularWithSize:(float)fontSize{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return [UIFont fontWithName:@"PSLxKittithada" size:fontSize];
    }
    return [UIFont fontWithName:@"PSLTextNewPro" size:fontSize];
}

+(UIFont *)fontBoldWithSize:(float)fontSize{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return [UIFont fontWithName:@"SCBPSLxKittithadaErgoBold" size:fontSize];
    }
    return [UIFont fontWithName:@"PSLTextNewProBold" size:fontSize];
}

@end
