//
//  TAGLKView.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "TASquareObject.h"
#import "TASphereObject.h"
#import "TAGLKViewController.h"

@interface TAGLKView : GLKView

@property (strong, nonatomic) GLKViewController *myViewController;

-(id) initWithFrame:(CGRect)frame;

-(void) setTexture:(NSMutableData*)data width:(int)width height:(int)height dataDict:(NSMutableDictionary *)dataDict rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY;

-(void) draw;
@end
