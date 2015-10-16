//
//  TABasicViewController.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/16.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TABasicViewController.h"

@interface TABasicViewController ()

@end

@implementation TABasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self createTitleView];
}

- (void)createTitleView
{
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 70)];
    self.titleView.backgroundColor = [UIColor colorWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:1];
    [self.view addSubview:self.titleView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((1024/2) - (300/2), 20, 300, 50)];
    [self.titleView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:35];
    self.titleLabel.textAlignment = 1;
}

- (void)setTitleText:(NSString *)titleString
{
    self.titleLabel.text = titleString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
