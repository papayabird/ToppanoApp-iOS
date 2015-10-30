//
//  TAHomeViewController.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/29.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TAHomeViewController.h"
#import "TAMainViewController.h"

@interface TAHomeViewController()

{
    MBProgressHUD *hud;
}

@end




@implementation TAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleText:@"HOME"];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];

    [self loginAndGetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - Login
- (void)loginAndGetData
{
    
#warning 這邊因為server還沒有紀錄userid所以每次都要call登入,每次跟FB fetch
    
    hud.labelText = @"登入中請稍候";
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error)
         {
             
             [hud show:YES];
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                 
                 [[TANetworkAPI sharedManager] loginWith:result[@"id"] name:result[@"name"] birthday:result[@"birthday"] emails:result[@"email"] bio:result[@"bio"] location:result[@"location"] complete:^(BOOL isSuccess, NSError *err, id responseObject) {
                     
                     [hud hide:YES];
                     
                     dispatch_async(dispatch_get_main_queue(), ^(void) {
                         
                         if (isSuccess) {
                             [AppDelegate sharedAppDelegate].userId = responseObject[@"userid"];
                         }
                         else {
                             
                             NSString *titleString = NSLocalizedString(@"登入失敗", @"String");
                             NSString *cancelString = NSLocalizedString(@"確認", @"String");
                             
                             [RMUniversalAlert showAlertInViewController:self withTitle:titleString message:@"" cancelButtonTitle:cancelString destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
                                 
                                 [self.navigationController popViewControllerAnimated:YES];
                             }];
                             NSLog(@"Error %@",err);
                         }
                     });
                 }];
             });
         }
     }];
}

#pragma mark - Button Action
- (IBAction)logoutAction:(id)sender
{
    NSString *titleString = NSLocalizedString(@"確定要登出?", @"String");
    NSString *cancelString = NSLocalizedString(@"取消!", @"String");
    NSString *destructivetring = NSLocalizedString(@"確定!", @"String");
    
    [RMUniversalAlert showAlertInViewController:self withTitle:titleString message:@"" cancelButtonTitle:cancelString destructiveButtonTitle:destructivetring otherButtonTitles:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
        if (buttonIndex == alert.cancelButtonIndex) {
            NSLog(@"Cancel Tapped");
        } else if (buttonIndex == alert.destructiveButtonIndex) {
            NSLog(@"Delete Tapped");
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (IBAction)claenDataAction:(id)sender
{
    NSString *titleString = NSLocalizedString(@"確定要刪除?", @"String");
    NSString *cancelString = NSLocalizedString(@"取消!", @"String");
    NSString *destructivetring = NSLocalizedString(@"確定!", @"String");
    
    [RMUniversalAlert showAlertInViewController:self withTitle:titleString message:@"" cancelButtonTitle:cancelString destructiveButtonTitle:destructivetring otherButtonTitles:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
        if (buttonIndex == alert.cancelButtonIndex) {
            NSLog(@"Cancel Tapped");
        } else if (buttonIndex == alert.destructiveButtonIndex) {
            NSLog(@"Delete Tapped");
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            [fileManager removeItemAtPath:[[TAFileManager returnDocumentPath] stringByAppendingPathComponent:kTAMapDir] error:nil];
        }
    }];
}

- (IBAction)myBuildCaseAction:(id)sender
{
    TAMainViewController *mainVC = [[TAMainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (IBAction)historyAction:(id)sender
{
    
}

- (IBAction)settingAction:(id)sender {
}
@end
