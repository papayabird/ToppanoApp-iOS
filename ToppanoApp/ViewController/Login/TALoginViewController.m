//
//  TALoginViewController.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TALoginViewController.h"
#import "TAHomeViewController.h"
@interface TALoginViewController ()

{
    
}

@end

@implementation TALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleText:@"TOPPANO"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Button Action

- (IBAction)FBloginAction:(id)sender
{
    [self loginFB];
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
                 
                 TAHomeViewController *homeVC = [[TAHomeViewController alloc] init];
                 homeVC.userDict = result;
                 [self.navigationController pushViewController:homeVC animated:YES];
            }
             else
             {
                 NSString *titleString = NSLocalizedString(@"FB撈取資料失敗", @"String");
                 NSString *cancelString = NSLocalizedString(@"確認", @"String");
                 
                 [RMUniversalAlert showAlertInViewController:self withTitle:titleString message:@"" cancelButtonTitle:cancelString destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){

                     
                 }];
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    else {
        
    }
}

@end
