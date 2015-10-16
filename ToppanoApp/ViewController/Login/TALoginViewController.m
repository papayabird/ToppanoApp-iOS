//
//  TALoginViewController.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TALoginViewController.h"
#import "TAMainViewController.h"
@interface TALoginViewController ()


@end

@implementation TALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self setTitleText:@"TOPPANO"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    /*
    if ([FBSDKAccessToken currentAccessToken]){
        //還在登入中,直接fetch再拿mail給server
        [self fetchUserInfo];
    }
    else {
        //要做登入,按鈕要顯示
    }
     */
}

#pragma mark - Button Action

- (IBAction)FBloginAction:(id)sender
{
    TAMainViewController *mainVC = [[TAMainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
    /*
    [self loginFB];
     */
}

#pragma mark - FB Methods

- (void)loginFB
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self fetchUserInfo];
         }
     }];
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 //拿mail
                 
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    else {
        
    }
}

@end
