//
//  AppDelegate.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "BaseNaviViewController.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"
#import "MineViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setIQKeyboardManager];
    [self judgeFirstView];
    
    
    
    return YES;
}

//配置键盘管理
- (void)setIQKeyboardManager{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)judgeFirstView{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    HomeViewController *homeVC = [HomeViewController new];
    //LoginViewController *loginVC = [LoginViewController new];
    MineViewController *mine = [[MineViewController alloc]init];
    BaseNaviViewController *navi = [[BaseNaviViewController alloc] initWithRootViewController:mine];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
