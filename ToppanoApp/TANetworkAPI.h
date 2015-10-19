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
- (void)loginWith:(NSString *)account password:(NSString *)password complete:(TARequestFinishBlock)completeBlock;
#pragma mark - 拿場景metadata & photos
- (void)getPhotoMetadataAndImageWithIndex:(NSString *)index complete:(TARequestFinishBlock)completeBlock;

@end
