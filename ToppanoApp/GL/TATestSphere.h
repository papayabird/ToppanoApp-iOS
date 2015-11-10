//
//  TATestSphere.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/27.
//  Copyright © 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface TATestSphere : NSObject

@property (nonatomic) int textureTag __unavailable;

@property (nonatomic) int textureMode __unavailable;

@property (strong, nonatomic) GLKTextureInfo *textureInfo __unavailable;

- (TATestSphere *)init:(float)radius widthSegments:(float)widthSegments heightSegments:(float)heightSegments phiStart:(float)phiStart phiLength:(float)phiLength thetaStart:(float)thetaStart thetaLength:(float)thetaLength __unavailable;

-(void) draw:(GLint) posLocation uv:(GLint) uvLocation textureModeSlot:(GLint)_textureModeSlot tex:(GLint )uTex __unavailable;

@end
