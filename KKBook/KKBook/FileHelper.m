//
//  FileHelper.m
//  MoMagPad
//
//  Created by Disakul Waidee on 10/20/10.
//  Copyright 2010 Digix Technology. All rights reserved.
//

#import "FileHelper.h"
#import <sys/xattr.h>
#import "ZipArchive.h"

@implementation FileHelper


#pragma mark -
#pragma mark return file with Megabyte

+(float)fileSizeAtPath:(NSString*)path{
	float fileSize = (float)[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
	float fileSizeMB = fileSize/(1024.0f*1024.0f);
	return fileSizeMB;
}

+(unsigned long long int)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

+(BOOL)removeDirAtPath:(NSString*)path{
    if (!path) {
		return NO;
	}
	
	if (![self fileExists:path isDir:YES]) {
		return NO;
	}
	
	NSError *error = nil;
	NSFileManager * filemanager = [NSFileManager defaultManager];
	if ([filemanager removeItemAtPath:path error:&error]) {
		return YES;
	}else {
		return NO;
	}
}

+(BOOL)removeAtPath:(NSString*)path{
	
    NSLog(@"Delete %@",path);
    
	if (!path) {
		return NO;
	}
	
	if (![self fileExists:path isDir:NO]) {
		return NO;
	}
	
	NSError *error = nil;
	NSFileManager * filemanager = [NSFileManager defaultManager];
	if ([filemanager removeItemAtPath:path error:&error]) {
		return YES;
	}else {
		return NO;
	}
}

+(BOOL)createAtPath:(NSString*)path{
	
	NSFileManager * filemanager = [NSFileManager defaultManager];
	if ([filemanager fileExistsAtPath:path]) {
		return YES;
	}
	NSError *error = nil;
	if ([filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
		return YES;
	}else {
		return NO;
	}
}

+(BOOL)fileExists:(NSString*)path isDir:(BOOL)isDir{
	
	NSFileManager * filemanager = [NSFileManager defaultManager];
	return [filemanager fileExistsAtPath:path isDirectory:&isDir];
}

+(NSString *)documentDirPath{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+(NSString *)bundlePath{
	return [[NSBundle mainBundle] resourcePath];
}

+(NSString *) booksPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [paths objectAtIndex:0];
    NSString *bundlePath = [libraryPath stringByAppendingPathComponent:@"KKBook"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:bundlePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:bundlePath]];
    }
	return bundlePath;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+(NSString*)previewPath{
    
    NSString *path = [[FileHelper tempDirPath] stringByAppendingPathComponent:@"previews"];
    if([FileHelper fileExists:path isDir:YES])
        [FileHelper createAtPath:path];
    
	return path;
}

+(NSString*)coversPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [paths objectAtIndex:0];
    NSString *path = [libraryPath stringByAppendingPathComponent:@"covers"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    }
    
	return path;
}

+(NSString*)searchPhysicalFilePath:(NSString*)filename{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
	
	if ([fileManager fileExistsAtPath:filePath] == NO) {
		
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
		
		if (![fileManager fileExistsAtPath:path]) {
			NSLog(@"File %@ does not exists in bundle",path);
		}else {
			
			// Copy file from bundle to document
			NSError *err = nil;
			[fileManager copyItemAtPath:path toPath:filePath error:&err];
			if (err != nil) {
				NSLog(@"Copy file error %@",err);
			}
		}
		
	}
	return filePath;
}

+(BOOL)copyFile:(NSString*)source to:(NSString*)destination{
    
    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
        return [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:nil];
    return NO;
}

+(NSString *)tempDirPath{
    return NSTemporaryDirectory();
}

+(NSString *)cacheDirPath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                          NSUserDomainMask,
                                                          YES) lastObject];
}

+(NSString *)videoPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [paths objectAtIndex:0];
    NSString *bundlePath = [libraryPath stringByAppendingPathComponent:@"privatedocuments"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:bundlePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
	return bundlePath;
}

+(BOOL) extractFile:(NSString *)path outputPath:(NSString *) destPath{
	if (![FileHelper fileExists:path isDir:NO]) {
		NSLog(@"File %@ not exists",path);
		return NO;
	}
	
	BOOL ret = NO;
	ZipArchive* za = [[ZipArchive alloc] init];
	
	if( [za UnzipOpenFile:path Password:PASSWORD_UNZIP] )
    //if( [za UnzipOpenFile:path]) //for test
		// if the Password is empty, get same  effect as if( [za UnzipOpenFile:@"/Volumes/data/testfolder/Archive.zip"] )
	{
		ret = [za UnzipFileTo:destPath overWrite:YES];
		[za UnzipCloseFile];
	}else {
		return NO;
	}
	
	return ret;
}


@end
