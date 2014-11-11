//
//  Macro.h
//  KKBooK
//
//  Created by PromptNow Ltd. on 30/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#ifndef KKBooK_Macro_h
#define KKBooK_Macro_h

#ifdef DEBUG
#define JLLog(fmt,...) NSLog((@"JLLOG %s-%d:" fmt),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define JLLog(...)
#else
#define JLLog(...)
#endif

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define appDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define CHILD_MARGIN 10
#define CHILD_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds) - 20

#define FLAG_TEST @"N"

#define KKBOOK_KEY @"KKBook"
#define DOWNLOADING @"DOWNLOADING"
#define DOWNLOADFAIL @"DOWNLOADFAIL"
#define DOWNLOADCOMPLETE @"DOWNLOADCOMPLETE"
#define DOWNLOADWAITING @"DOWNLOADWAITING"

#define BookDidStart @"BookDidStart"
#define BookDidResponce @"BookDidResponce"
#define BookDidFail @"BookDidFail"
#define BookDidFinish @"BookDidFinish"

#define PASSWORD_ENCRYPT @"GLive2014KKBOOKKAENkhon"
#define PASSWORD_UNZIP @"kkBook2014KaenKhon&nine&lek"

#endif