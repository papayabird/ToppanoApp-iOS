//
//  TANetworkAPI.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OTRequestFinishBlock)(BOOL isSuccess, NSError *err, id responseObject);

@interface TANetworkAPI : NSObject

+(instancetype)sharedManager;

- (void)getPhotoMetadataAndImageWithIndex:(NSString *)index complete:(OTRequestFinishBlock)completeBlock;

@end
