//
//  TASquareObject.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TASquareObject : NSObject

#pragma mark - 必要參數

@property (nonatomic) int textureMode;
@property (nonatomic) NSString *transformPageIndex;

@property (strong, nonatomic) GLKTextureInfo *textureInfo;

#pragma mark - 必要方法
- (instancetype)initSize:(float)size radius:(float)radius transformPage:(NSString *)transformPage transfromTheta:(float)transfromTheta transfromPhi:(float)transfromPhi rotationX:(float)rotationX rotationY:(float)rotationY rotationZ:(float)rotationZ;

-(void) draw:(GLint) posLocation uv:(GLint) uvLocation textureModeSlot:(GLint)_textureModeSlot tex:(GLint )uTex2;

- (NSMutableArray *)getObjectvectorArray;

@end
