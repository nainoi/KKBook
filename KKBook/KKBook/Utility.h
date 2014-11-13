//
//  Utility.h
//  SusanooLib
//
//  Created by Narongdet Intharasit on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject {
    
}

+ (NSString *) platform;
+ (NSString *) platformString;
+ (NSString *) getDeviceUDID;
+ (BOOL) isPad;
+ (BOOL)isRetina;
+ (BOOL)isLessPhone5;
+ (NSString *) getDeviceType;
+ (NSString *) getDocumentPath;

@end
