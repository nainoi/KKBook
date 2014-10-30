//
//  NSString+NSString.m
//  SCBEASY
//
//  Created by Ittipong on 3/10/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import "NSString+SCBString.h"

@implementation NSString (NSString)
static BOOL currentLanguage;

-(NSString *)removeNullString{
    
    if ([self isEqualToString:@"(null)"]) {
        return @"";
    }
    return self;

}
- (BOOL) containsString: (NSString*) substring
{
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

+(NSString*)removeNullString:(NSString*)string
{
    NSString *ans = [NSString stringWithFormat:@"%@",string];
    return [ans stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
}

+(NSString*)changeNullString:(NSString*)string WithString:(NSString*)changeString
{
    
    NSString *ans = [NSString stringWithFormat:@"%@",string];
    ans = [ans stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    if([ans isEqualToString:@""])
    {
        ans = changeString;
    }
    
    return ans;
}
+(NSString*)ThaiString:(NSString *)thaiString EngString:(NSString *)engString
{
    
    if([NSString getCurrentLanguage])
    {
        return [NSString removeNullString:engString];
    }
    else
    {
        return [NSString removeNullString:thaiString];
    }
}

+(BOOL)isEmailValid:(NSString *)string
{
    
    NSString *expression = @"^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (match){
        JLLog(@"MATCH");
        return YES;
    }else{
        JLLog(@"NOT MATCH");
        return NO;
    }
}
+(NSString*)stringOfAmount:(NSString *)amount
{
    if(!amount)
    {
        return @"-";
    }else if ([amount isEqualToString:@"**"]) {
        return @"*";
    }
    
    //amount = [NSString stringWithCurrencyformat:amount];
    
    amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    //[formatter setNumberStyle: NSNumberFormatterNoStyle];
    //[formatter setGroupingSeparator:@","];
    //[formatter setGroupingSize: 3];
    //[formatter setUsesGroupingSeparator: YES];
    
    //NSLog(@"%f",[NSNumber numberWithDouble:[amount doubleValue]].doubleValue);
    //NSNumber* aNumber = [NSNumber numberWithDouble:[amount doubleValue]];
    
    //return [formatter stringFromNumber: aNumber];
    return amount;
}

+(double)stringWithCommatoFloat:(NSString *)text
{
    NSString *temp = [[NSString alloc] initWithFormat:@"%@", [text stringByReplacingOccurrencesOfString:@"," withString:@""]];
    return [temp doubleValue];
}

+(NSString *)getStringForKey:(NSString *)key{
    
    NSString *str ;
    NSString *path;
    
    if (currentLanguage) {
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"th" ofType:@"lproj"];
    }
    
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    str = [languageBundle localizedStringForKey:key value:@"" table:nil];
    
    return str;
}
+(BOOL)getCurrentLanguage{
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSString *language = [prefs stringForKey:@"Language"];
    
    if (currentLanguage) {
        currentLanguage = YES;
        return currentLanguage;
    }else{
        currentLanguage = NO;
        return currentLanguage;
    }
    
}
+(NSString *)getCurrentLanguageString{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *language = [prefs stringForKey:@"Language"];
    NSLog(@"%@",language);
    
    if ([language isEqualToString:@"en"]) {
        currentLanguage = YES;
        return @"E";
    }else{
        currentLanguage = NO;
        return @"T";
    }
    
}

+(void)setLangguage:(BOOL)langguage{
    
//    [SCBUserDefault sharedInstance].languageString = langguage ? @"en" : @"th";
//    
//    currentLanguage = langguage;
}

+(NSString *)stringWithCurrencyformat:(NSString *)crrency{
    
    [crrency removeNullString];
    
    
    if ([crrency isEqualToString:@""]||[crrency isEqualToString:@" "]||crrency == nil) {
        return @"";
    }
    
    //check prefix (+ or -)
    NSString *prefix = @"";
    if ([crrency hasPrefix:@"-"]) {
        crrency =  [crrency stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        prefix = @"-";
    }else if ([crrency hasPrefix:@"+"]){
        crrency = [crrency stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
    // check * and set format
    if (![crrency isEqualToString:@"*"]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencySymbol:@""];
		crrency = [NSString stringWithFormat:@"%@%@",prefix,[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[crrency doubleValue]]]];
    }
    
    
    return crrency;
}
+(NSString *)stringWithCurrencyformat:(NSString *)crrency decimaMax:(NSInteger)maxLengthl{
    
    [crrency removeNullString];
    
    
    if ([crrency isEqualToString:@""]||[crrency isEqualToString:@" "]||crrency == nil) {
        return @"";
    }
    
    //check prefix (+ or -)
    NSString *prefix = @"";
    if ([crrency hasPrefix:@"-"]) {
        crrency =  [crrency stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        prefix = @"-";
    }else if ([crrency hasPrefix:@"+"]){
        crrency = [crrency stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
    // check * and set format
    if (![crrency isEqualToString:@"*"]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencySymbol:@""];
        [numberFormatter setMinimumFractionDigits:maxLengthl];
		crrency = [NSString stringWithFormat:@"%@%@",prefix,[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[crrency doubleValue]]]];
    }
    
    
    return crrency;
}
+(NSString *)stringWithUnitsformat:(NSString *)units{
    
    [units removeNullString];
    
    
    if ([units isEqualToString:@""]||[units isEqualToString:@" "]||units == nil) {
        return @"";
    }
    
    //check prefix (+ or -)
    NSString *prefix = @"";
    if ([units hasPrefix:@"-"]) {
        units =  [units stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        prefix = @"-";
    }else if ([units hasPrefix:@"+"]){
        units = [units stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
    // check * and set format
    if (![units isEqualToString:@"*"]) {
        if ([units containsString:@"."]) {
            NSArray *uArray = [units componentsSeparatedByString:@"."];
            NSString *u1 = [self stringWithCurrencyformat:uArray[0] decimaMax:0];
            NSString *u2 = uArray[1];
            units = [NSString stringWithFormat:@"%@.%@", u1, u2];
        }
    }
    
    return units;
}
+(NSString *)stringWithTelephoneNumberFormat:(NSString *)tenDigitNumber{
    return [tenDigitNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d{4})"
                                                     withString:@"$1-$2-$3"
                                                        options:NSRegularExpressionSearch
                                                          range:NSMakeRange(0, [tenDigitNumber length])];
}

+(NSString*)stringOfTelephoneNumber:(NSString *)telephoneFormat{
    return [telephoneFormat stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
-(NSMutableArray *)spritStringToArray{
    NSString *myString = self;
    
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[myString length]];
    for (int i=0; i < [myString length]; i++) {

        NSRange rage =[myString rangeOfComposedCharacterSequenceAtIndex:i];
        
        [characters addObject:[myString substringWithRange:rage]];
    }
    return characters;
}

@end
