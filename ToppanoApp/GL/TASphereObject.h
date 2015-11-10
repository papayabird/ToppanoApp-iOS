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

@property (nonatomic) int textureMode __unavailable;

@property (strong, nonatomic) GLKTextureInfo *textureInfo __unavailable;

-(id) init:(GLfloat)radius divide:(int) divide __unavailable;

-(void) draw:(GLint) posLocation uv:(GLint) uvLocation textureModeSlot:(GLint)_textureModeSlot tex:(GLint )uTex __unavailable;

@end
