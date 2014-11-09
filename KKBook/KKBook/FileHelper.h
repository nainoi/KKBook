//
//  FileHelper.h
//  MoMagPad
//
//  Created by Disakul Waidee on 10/20/10.
//  Copyright 2010 Digix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject {

}

+(unsigned long long int)folderSize:(NSString *)folderPath;
+(float)fileSizeAtPath:(NSString*)path;
+(BOOL)removeAtPath:(NSString*)path;
+(BOOL)removeDirAtPath:(NSString*)path;
+(BOOL)createAtPath:(NSString*)path;
+(BOOL)fileExists:(NSString*)path isDir:(BOOL)isDir;
+(NSString *)documentDirPath;
+(NSString *)tempDirPath;
+(NSString *)cacheDirPath;
+(NSString *)bundlePath;
+(NSString*)booksPath;
+(NSString*)coversPath;
+(NSString*)previewPath;
+(NSString*)videoPath;
+(NSString*)searchPhysicalFilePath:(NSString*)filename;
+(BOOL)copyFile:(NSString*)source to:(NSString*)destination;
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+(BOOL) extractFile:(NSString *)path outputPath:(NSString *) destPath;

@end
