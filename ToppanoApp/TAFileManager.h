//
//  TAFileManager.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/28.
//  Copyright © 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAFileManager : NSObject

+ (NSString *)returnSpaceFolderPath:(NSString *)floderName;

+ (NSString *)returnPhotoFilePathWithFileName:(NSString *)floderName photoFileName:(NSString *)photoFileName;

+ (NSMutableArray *)getAllMapPlistFromMapFile;

@end
