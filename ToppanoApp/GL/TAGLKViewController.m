//
//  TAGLKViewController.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TAGLKViewController.h"
#import "TAGLKView.h"
@interface TAGLKViewController ()

{
    TAGLKView *glRenderView;
}

@end

@implementation TAGLKViewController

+(instancetype)sharedManager
{
    static TAGLKViewController *sharedStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStorage = [[TAGLKViewController alloc] init];
    });
    return sharedStorage;
}

/**
 * gateway method for GLView settings
 */
-(id)init:(CGRect)rect image:(NSMutableData *)imageData width:(int)width height:(int)height dataDict:(NSMutableDictionary *)dataDict  rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY {
    self = [super init];
    
    glRenderView = [[TAGLKView alloc] initWithFrame:rect];
    [glRenderView setTexture:imageData width:width height:height dataDict:dataDict rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
    glRenderView.myViewController = self;
    self.view = glRenderView;
    
    return self;
}

#pragma mark - Other Methods

- (void)releaseRenderView
{
    [glRenderView removeFromSuperview];
    glRenderView = nil;
}

-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [glRenderView draw];
}

@end
