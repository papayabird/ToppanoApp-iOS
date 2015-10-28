//
//  TANetworkAPI.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TARequestFinishBlock)(BOOL isSuccess, NSError *err, id responseObject);

@interface TANetworkAPI : NSObject

+(instancetype)sharedManager;
#pragma mark - 登入
- (void)loginWith:(NSString *)fbId name:(NSString *)name birthday:(NSString *)birthday emails:(NSString *)emails bio:(NSString *)bio location:(NSString *)location complete:(TARequestFinishBlock)completeBlock;
#pragma mark - 拿取map
- (void)getMapWithUserId:(NSString *)userId complete:(TARequestFinishBlock)completeBlock;

#pragma mark - 拿場景metadata & photos
- (void)getPhotoMetadataAndImageWithIndex:(NSString *)index mapName:(NSString *)mapName complete:(TARequestFinishBlock)completeBlock;

@end
