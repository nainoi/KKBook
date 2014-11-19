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

#define FLAG_TEST @"Y"

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

// Background color for issues cover (before downloading the actual cover)
#define ISSUES_COVER_BACKGROUND_COLOR @"#ffffff"

// Title for issues in the shelf
// #define ISSUES_TITLE_FONT @"Helvetica"
// #define ISSUES_TITLE_FONT_SIZE 15
#define ISSUES_TITLE_COLOR @"#000000"

// Info text for issues in the shelf
// #define ISSUES_INFO_FONT @"Helvetica"
// #define ISSUES_INFO_FONT_SIZE 15
#define ISSUES_INFO_COLOR @"#929292"

#define ISSUES_PRICE_COLOR @"#bc242a"

// Download/read button for issues in the shelf
// #define ISSUES_ACTION_BUTTON_FONT @"Helvetica-Bold"
// #define ISSUES_ACTION_BUTTON_FONT_SIZE 11
#define ISSUES_ACTION_BUTTON_BACKGROUND_COLOR @"#bc242a"
#define ISSUES_ACTION_BUTTON_COLOR @"#ffffff"

// Archive button for issues in the shelf
// #define ISSUES_ARCHIVE_BUTTON_FONT @"Helvetica-Bold"
// #define ISSUES_ARCHIVE_BUTTON_FONT_SIZE 11
#define ISSUES_ARCHIVE_BUTTON_COLOR @"#bc242a"
#define ISSUES_ARCHIVE_BUTTON_BACKGROUND_COLOR @"#ffffff"

// Text and spinner for issues that are being loaded in the shelf
#define ISSUES_LOADING_LABEL_COLOR @"#bc242a"
#define ISSUES_LOADING_SPINNER_COLOR @"#929292"

// Progress bar for issues that are being downloaded in the shelf
#define ISSUES_PROGRESSBAR_TINT_COLOR @"#bc242a"


#endif