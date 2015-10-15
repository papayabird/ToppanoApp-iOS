//
//  TAMotion.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TAMotion.h"

@implementation TAMotion

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)start
{
    motionManager = nil;
    
    motionManager = [[CMMotionManager alloc] init];
    
    [motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
        
        CGFloat rotationRate = gyroData.rotationRate.y;
        
        if (fabs(rotationRate) >= 0.1f) {
            NSLog(@"%f",rotationRate);
            [self.delegate returnMotionCMGyroDataData:gyroData];
        }
        
    }];
    
}

@end
