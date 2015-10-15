//
//  TASphereObject.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface TASphereObject : NSObject

@property (nonatomic) int textureMode;

@property (strong, nonatomic) GLKTextureInfo *textureInfo;

-(id) init:(GLfloat)radius divide:(int) divide;

-(void) draw:(GLint) posLocation uv:(GLint) uvLocation textureModeSlot:(GLint)_textureModeSlot tex:(GLint )uTex;

@end
