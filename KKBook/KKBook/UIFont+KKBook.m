//
//  UIFont+Custom.m
//  SCBLife
//
//  Created by PromptNow on 10/10/2557 BE.
//  Copyright (c) 2557 Promptnow. All rights reserved.
//

#import "UIFont+KKBook.h"

@implementation UIFont (KKBook)

+(UIFont *)fontRegularWithSize:(float)fontSize{
    UIFont *font;
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        font = [UIFont fontWithName:@"PSLxKittithada" size:fontSize];
    }else{
        font = [UIFont fontWithName:@"PSLTextNewPro" size:fontSize];
    }
    
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+(UIFont *)fontBoldWithSize:(float)fontSize{
    UIFont *font;
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        font = [UIFont fontWithName:@"SCBPSLxKittithadaErgoBold" size:fontSize];
    }else{
        font = [UIFont fontWithName:@"PSLTextNewProBold" size:fontSize];
    }
    
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

@end
