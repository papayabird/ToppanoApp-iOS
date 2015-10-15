//
//  TAGLKViewController.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@protocol TAGLViewProtocol

-(void)transfromView:(int)pageIndex rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY;

@end

@interface TAGLKViewController : GLKViewController

@property (nonatomic) BOOL editType;

@property (weak,nonatomic) id <TAGLViewProtocol> tapDelegate;

+(instancetype)sharedManager;

-(id)init:(CGRect)rect image:(NSMutableData *)imageData width:(int)width height:(int)height dataDict:(NSMutableDictionary *)dataDict rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY;

- (void)releaseRenderView;

@end
