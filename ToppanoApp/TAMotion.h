//
//  TAMotion.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreGraphics/CoreGraphics.h>
@protocol returnMotionDataDelegate <NSObject>

@required
- (void)returnMotionCMGyroDataData:(CMGyroData *)data;

@optional
- (void)returnMotionCMAccelerometerDataData:(CMAccelerometerData *)data;



@end

@interface TAMotion : NSObject

{
    CMMotionManager *motionManager;
}

@property (strong, nonatomic) id <returnMotionDataDelegate> delegate;

- (void)start;


@end

