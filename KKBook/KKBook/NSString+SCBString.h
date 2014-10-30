//
//  NSString+NSString.h
//  SCBEASY
//
//  Created by Ittipong on 3/10/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString)

- (BOOL) containsString: (NSString*) substring;
-(NSString *)removeNullString;
+(NSString*)removeNullString:(NSString*)string;
+(NSString*)changeNullString:(NSString*)string WithString:(NSString*)changeString;

+(BOOL)isEmailValid:(NSString*)string;
+(NSString *)stringWithCurrencyformat:(NSString *)crrency;
+(NSString *)stringWithCurrencyformat:(NSString *)crrency decimaMax:(NSInteger)maxLengthl;
+(NSString *)stringWithUnitsformat:(NSString *)units;
+(NSString *)stringWithTelephoneNumberFormat:(NSString *)number;
+(NSString*)stringOfTelephoneNumber:(NSString *)telephoneFormat;

+(NSString*)stringOfAmount:(NSString *)amount;
+(double)stringWithCommatoFloat:(NSString *)text;


+(NSString *)getStringForKey:(NSString *)key;
+(NSString*)ThaiString:(NSString *)thaiString EngString:(NSString *)engString;
+(BOOL)getCurrentLanguage;
+(NSString *)getCurrentLanguageString;
+(void)setLangguage:(BOOL)langguage;

-(NSMutableArray *)spritStringToArray;


@end
