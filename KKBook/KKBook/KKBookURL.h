//
//  KKBookURL.h
//  KKBooK
//
//  Created by PromptNow on 11/5/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#ifndef KKBooK_KKBookURL_h
#define KKBooK_KKBookURL_h

#define API_MAIN_URL @"http://www.geniuskids.tv/RestKKBooK/index.php/api/book/"

#define STORE_MAIN_URL [NSString stringWithFormat:@"%@getHomePage",API_MAIN_URL]
#define STORE_LIST_URL [NSString stringWithFormat:@"%@getBook",API_MAIN_URL]
#define PREVIEW_URL [NSString stringWithFormat:@"%@getPreview",API_MAIN_URL]
#define BANNER_URL [NSString stringWithFormat:@"%@getBanner",API_MAIN_URL]
#define CATEGORY_URL [NSString stringWithFormat:@"%@getCategory",API_MAIN_URL]

//for file
#define IMAGE_URL @"http://glive-ubuntu.cloudapp.net/kkbook/Resource/Book/"
#define BOOK_URL @"http://glive-ubuntu.cloudapp.net/kkbook/Resource/Book/"
#define BANNER_PATH_URL @"http://glive-ubuntu.cloudapp.net/kkbook/Resource/Banner/"
//#define IMAGE_URL @"http://glive-ubuntu.cloudapp.net/RestKKBooK/kkbook/Resource/"

#endif
