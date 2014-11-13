//
//  Utility.m
//  SusanooLib
//
//  Created by Narongdet Intharasit on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation Utility

#pragma mark - Hardware Info

+ (NSString *) platform  
{  
    size_t size;  
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);  
    char *machine = malloc(size);  
    sysctlbyname("hw.machine", machine, &size, NULL, 0);  
    //    NSString *platform = [NSString stringWithCString:machine];
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);  
    return platform;  
}  

+ (NSString *) platformString  
{  
    NSString *platform = [self platform];  
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad"; //first gen
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad"; //2nd gen wifi
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad"; //2nd gen 3G GSM
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad"; //2nd gen 3G CDMA
    if ([platform isEqualToString:@"i386"])         return @"iPad"; //Emulator
    return @"iPad"; //Else
} 

+ (NSString *) getDeviceVersion
{
    return [self platformString];
}

+ (NSString *) getDeviceUDID
{
    NSString *udid = [[UIDevice currentDevice] systemName];
    udid = [udid lowercaseString];
    udid = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return udid;
}

+ (BOOL) isPad {
if([[[UIDevice currentDevice] model] isEqual:@"iPhone"] || [[[UIDevice currentDevice] model] isEqual:@"iPhone Simulator"])
    return NO;
else
    return YES;
}

+ (BOOL)isRetina{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        // Retina
        return YES;
    } else {
        // Not Retina
        return NO;
    }
}

+(BOOL)isLessPhone5{
    if ([[UIScreen mainScreen] bounds].size.height < 568) {
        return YES;
    }else{
        return NO;
    }
}

//+ (NSString *) getUserAgent
//{
//    return USER_AGENT;
//}

+ (NSString *) getDeviceType
{
   //NSLog(@"Device Type = %@", [[UIDevice currentDevice] model]);
    
    if(([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) || ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])){
        return @"iphone";
    }else if([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]){
        return @"ipod";    
    }else if(([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) || ([[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"])){
        return @"ipad";
    }else{
        return @"unknow";
    }
    
}
+ (NSString *) getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
    //return @"/Users/PromptnowMacMini2/Desktop/";
}

+ (NSString *) getBookPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
    //return @"/Users/PromptnowMacMini2/Desktop/";
}

@end
