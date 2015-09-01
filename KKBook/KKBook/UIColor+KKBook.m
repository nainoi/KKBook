//
//  UIColor+SCBColor.m
//  SCBEASY
//
//  Created by Ittipong on 3/4/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import "UIColor+KKBook.h"

@implementation UIColor (KKBook)

+(UIColor *)KKBookNavigationColor{
    return [UIColor colorFromHexString:@"#75626A"];
}

+(UIColor *)KKBookOrangeColor{
    return [UIColor colorFromHexString:@"#F9A840"];
}

+(UIColor *)KKBookLightSeagreenColor{
    return [UIColor colorFromHexString:@"#20b2aa"];
}
+(UIColor *)KKBookMediumSeagreenColor{
    return [UIColor colorFromHexString:@"#3cb371"];
}
+(UIColor *)SCBPurpleColor{
    return [UIColor colorFromHexString:@"#675293"];
}
+(UIColor *)SCBLightPurpleColor{
    return [UIColor colorFromHexString:@"#806bab"];
}
+(UIColor *)SCBYellowColor{
    return [UIColor colorFromHexString:@"#f39633"];
}
+(UIColor *)SCBLightYellowColor{
    return [UIColor colorFromHexString:@"#faac59"];
}
+(UIColor *)SCBBlueColor{
    return [UIColor colorFromHexString:@"#1a9cab"];
}
+(UIColor *)SCBLightBlueColor{
    return [UIColor colorFromHexString:@"#41b4c2"];
}
+(UIColor *)SCBPinkColor{
    return [UIColor colorFromHexString:@"#d44c75"];
}
+(UIColor *)SCBLightPinkColor{
    return [UIColor colorFromHexString:@"#e56c91"];
}
+(UIColor *)SCBLightGrayBG{
    return [UIColor colorFromHexString:@"#F5F5F5"];
}
+(UIColor *)SCBAccSumBG{
    return [UIColor colorFromHexString:@"#eeeeee"];
}
+(UIColor *)SCBOrangeColor{
    return [UIColor colorFromHexString:@"#f39633"];
}
+(UIColor *)SCBGreenAlertColor{
    return [UIColor colorFromHexString:@"#4eaa3c"];
}
+(UIColor *)SCBPinkAlertColor{
    return [UIColor colorFromHexString:@"#ed6b65"];
}
+(UIColor *)SCBRedAlertColor{
    return [UIColor colorFromHexString:@"#c0392b"];
}
+(UIColor *)SCBFontWhiteColor{
      return [UIColor colorFromHexString:@"#333333"];
}
+(UIColor *)SCBGrayLv1Color{
    return [UIColor colorFromHexString:@"#777777"];
}
+(UIColor *)SCBGrayLv2Color{
    return [UIColor colorFromHexString:@"#999999"];
}
+(UIColor *)SCBGrayLv3Color{
    return [UIColor colorFromHexString:@"#cccccc"];
}
+(UIColor *)SCBGrayLv4Color{
    return [UIColor colorFromHexString:@"#dddddd"];
}
+(UIColor *)SCBGrayLv5Color{
    return [UIColor colorFromHexString:@"#f5f5f5"];
}
+(UIColor *)SCBCharcoalLv1Color{
    return [UIColor colorFromHexString:@"#47505c"];
}
+(UIColor *)SCBCharcoalLv2Color{
    return [UIColor colorFromHexString:@"#616973"];
}
+(UIColor *)SCBCharcoalLv3Color{
    return [UIColor colorFromHexString:@"#cccdcf"];
}
+(UIColor *)SCBTextGreenColor{
     return [UIColor colorFromHexString:@"#4eaa3c"];
}
+(UIColor *)SCBTextRedColor{
     return [UIColor colorFromHexString:@"#ed6b65"];
}
+(UIColor *)SCBTextBlackColor{
     return [UIColor colorFromHexString:@"#333333"];
}
+(UIColor *)SCBTextGrayColor{
     return [UIColor colorFromHexString:@"#777777"];
}
#pragma mark - convert hex to rgb
+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
