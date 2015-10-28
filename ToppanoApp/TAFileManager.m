//
//  TAFileManager.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/28.
//  Copyright © 2015年 papayabird. All rights reserved.
//

#import "TAFileManager.h"

@implementation TAFileManager

+ (NSString *)returnSpaceFolderPath:(NSString *)floderName
{
    NSString *Path = [[NSHomeDirectory() stringByAppendingPathComponent:kTAMapDir] stringByAppendingPathComponent:floderName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    
    BOOL isExist =  [fileManager fileExistsAtPath:Path isDirectory:&isDir];
    
    if (isExist == NO || isDir == NO) {
        
        BOOL createSuccess = [fileManager createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
        if (createSuccess == NO) {
            
            return nil;
        }
    }
    return Path;
}

+ (NSString *)returnPhotoFilePathWithFileName:(NSString *)floderName photoFileName:(NSString *)photoFileName
{
    NSString *Path = [[self returnSpaceFolderPath:floderName] stringByAppendingPathComponent:photoFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    
    BOOL isExist =  [fileManager fileExistsAtPath:Path isDirectory:&isDir];
    
    if (isExist == NO || isDir == NO) {
        
        BOOL createSuccess = [fileManager createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
        if (createSuccess == NO) {
            
            return nil;
        }
    }
    
    return Path;
}

+ (NSMutableArray *)getAllMapNameFromMapFile
{
    //取得資料夾中所有檔名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator* dirEnum = [fileManager enumeratorAtPath:[NSHomeDirectory() stringByAppendingPathComponent:kTAMapDir]];
    NSLog(@"Documentsdirectory: %@",[fileManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:kTAMapDir] error:nil]); //印出path中的資料夾
    NSString* path;
    
    NSMutableArray *spaceDirNameArray = [NSMutableArray array];
    
    while ((path = [dirEnum nextObject]) != nil) {
        if ([[path pathComponents] count] == 1) {
            if (![path isEqualToString:@".DS_Store"]) {
                
                [spaceDirNameArray addObject:path];
            }
        }
    }
    return spaceDirNameArray;
}

+ (NSMutableArray *)getAllMapPlistFromMapFile
{
    //取得資料夾中所有檔名
    NSMutableArray *spaceDirDataArray = [NSMutableArray array];

    NSMutableArray *array = [self getAllMapNameFromMapFile];
    for (NSString *fileName in array) {
      
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[[[NSHomeDirectory() stringByAppendingPathComponent:kTAMapDir] stringByAppendingPathComponent:fileName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@map.plist",fileName]]];
        
        [spaceDirDataArray addObject:dict];
    }
    
    return spaceDirDataArray;
}

@end
