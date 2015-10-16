//
//  TABasicViewController.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/16.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TABasicViewController : UIViewController

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLabel;

- (void)setTitleText:(NSString *)titleString;

@end
