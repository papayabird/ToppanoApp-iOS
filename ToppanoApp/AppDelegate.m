//
//  AppDelegate.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "AppDelegate.h"

#import "TALoginViewController.h"
#import "TAHomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate
{
    return (id)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //FB
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    
    [self settingRootVC];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)settingRootVC
{
    if ([FBSDKAccessToken currentAccessToken]){
        //還在登入中
        
        TALoginViewController *loginVC = [[TALoginViewController alloc] init];
        TAHomeViewController *homeVC = [[TAHomeViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] init];
        nav.viewControllers = @[loginVC, homeVC];
        nav.navigationBar.hidden = YES;
        [self.window setRootViewController:nav];
    }
    else {
        //要登入
        TALoginViewController *mainVC = [[TALoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        nav.navigationBar.hidden = YES;
        [self.window setRootViewController:nav];
    }
}

- (void)settingData
{
    /*
     [
     {
     photoName:
     buttonArray[
     {
     buttonPostion:
     pressToImageIndex:
     }
     ]
     }
     ]
     */
    /*
    self.dataArray = [NSMutableArray array];
    
    NSMutableDictionary *dict0 = [NSMutableDictionary dictionary];
    [dict0 setObject:@"0.JPG" forKey:@"photoName"];
    [dict0 setObject:@"0_s.JPG" forKey:@"sphotoName"];
    [dict0 setObject:@[
                       @{
                           @"lat": @"-17",
                           @"lng": @"-60",
                           @"size": @"22",
                           @"rotateX": @"95",
                           @"rotateY": @"100",
                           @"rotateZ": @"0",
                           @"nextID": @"00000001"
                           },
                       ] forKey:@"transition"];
    
    [self.dataArray addObject:dict0];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"1.JPG" forKey:@"photoName"];
    [dict1 setObject:@"1_s.JPG" forKey:@"sphotoName"];
    [dict1 setObject:@[
                       @{
                           @"buttonPostion":@{@"lat":@"-130",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"180",@"rotationY":@"0",@"rotationZ":@"-100"},
                           @"pressToImageIndex":@"0"
                           },
                       @{
                           @"buttonPostion":@{@"lat":@"90",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"100",@"rotationY":@"0",@"rotationZ":@"-90"},
                           @"pressToImageIndex":@"2"
                           }
                       ] forKey:@"buttonArray"];
    
    [self.dataArray addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"2.JPG" forKey:@"photoName"];
    [dict2 setObject:@"2_s.JPG" forKey:@"sphotoName"];
    [dict2 setObject:@[
                       @{
                           @"buttonPostion":@{@"lat":@"-100",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"270",@"rotationY":@"0",@"rotationZ":@"-90"},
                           @"pressToImageIndex":@"1"
                           },
                       @{
                           @"buttonPostion":@{@"lat":@"90",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"90",@"rotationY":@"0",@"rotationZ":@"-90"},
                           @"pressToImageIndex":@"3"
                           }
                       ] forKey:@"buttonArray"];
    
    [self.dataArray addObject:dict2];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"3.JPG" forKey:@"photoName"];
    [dict3 setObject:@"3_s.JPG" forKey:@"sphotoName"];
    [dict3 setObject:@[
                       @{
                           @"buttonPostion":@{@"lat":@"-90",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"270",@"rotationY":@"0",@"rotationZ":@"-90"},                           @"pressToImageIndex":@"2"
                           },
                       @{
                           @"buttonPostion":@{@"lat":@"80",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"90",@"rotationY":@"0",@"rotationZ":@"-90"},                           @"pressToImageIndex":@"4"
                           }
                       ] forKey:@"buttonArray"];
    
    [self.dataArray addObject:dict3];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setObject:@"4.JPG" forKey:@"photoName"];
    [dict4 setObject:@"4_s.JPG" forKey:@"sphotoName"];
    [dict4 setObject:@[
                       @{
                           @"buttonPostion":@{@"lat":@"-90",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"270",@"rotationY":@"0",@"rotationZ":@"-90"},                            @"pressToImageIndex":@"3"
                           },
                       @{
                           @"buttonPostion":@{@"lat":@"90",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"90",@"rotationY":@"0",@"rotationZ":@"-90"},                            @"pressToImageIndex":@"5"
                           }
                       ] forKey:@"buttonArray"];
    
    [self.dataArray addObject:dict4];
    
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
    [dict5 setObject:@"5.JPG" forKey:@"photoName"];
    [dict5 setObject:@"5_s.JPG" forKey:@"sphotoName"];
    [dict5 setObject:@[
                       @{
                           @"buttonPostion":@{@"lat":@"-90",@"long":@"-30"},
                           @"buttonRotation":@{@"rotationX":@"270",@"rotationY":@"0",@"rotationZ":@"-90"},                             @"pressToImageIndex":@"4"
                           },
                       ] forKey:@"buttonArray"];
    
    [self.dataArray addObject:dict5];
    */
}


+ (BOOL)isPad
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        return YES; /* Device is iPad */
    }
    return NO;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
