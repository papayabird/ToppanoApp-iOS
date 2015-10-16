//
//  TASceneViewController.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TATableViewCell.h"
#import "TAGLKViewController.h"

@interface TASceneViewController : TABasicViewController <UITableViewDataSource, UITableViewDelegate,TAGLViewProtocol>

@property (strong, nonatomic) NSString *spaceIndex;

@end
