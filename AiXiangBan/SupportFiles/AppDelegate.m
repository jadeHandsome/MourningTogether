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
#import "QYSDK.h"
#import "QYSessionViewController.h"
#import "XLJNewFetureController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#define EzvizAppKey @"d8550d61c51642669567ccf473a1d752"
#define EZPushAppSecret @"4d4037b10a3ce40056a702dea61e52e9"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[QYSDK sharedSDK] registerAppId:@"3cbd21513865110d300054b3d9184d13" appName:@"孝相伴"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setIQKeyboardManager];
    [self judgeFirstView];
    [self setEZOpen];
    [AMapServices sharedServices].apiKey = @"6f4c1f303c438c5bdc6fb7f23389684e";
    [AMapServices sharedServices].enableHTTPS = YES;
    return YES;
}

//配置键盘管理
- (void)setIQKeyboardManager{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[QYSessionViewController class]];
    
}

//萤石出事话
- (void)setEZOpen{
    [EZOPENSDK initLibWithAppKey:EzvizAppKey];
    [EZOPENSDK enableP2P:YES];
    [EZOPENSDK setDebugLogEnable:YES];
    [EZOPENSDK initPushService];
    NSLog(@"EZOpenSDK Version = %@", [EZOPENSDK getVersion]);
}


- (void)judgeFirstView{
    
    
    NSString *isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"];
    HomeViewController *homeVC = [HomeViewController new];
    LoginViewController *loginVC = [LoginViewController new];
    BaseNaviViewController *navi = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] integerValue]) {
            [[KRUserInfo sharedKRUserInfo] setValuesForKeysWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
            navi = [[BaseNaviViewController alloc] initWithRootViewController:homeVC];
        } else {
            navi = [[BaseNaviViewController alloc] initWithRootViewController:loginVC];
        }
        
    } else {
        navi = [[BaseNaviViewController alloc] initWithRootViewController:loginVC];
    }
    
    //BaseNaviViewController *navi = [[BaseNaviViewController alloc] initWithRootViewController:loginVC];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (!isFirst) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirst"];
        NSArray *arr = @[@"yd1",@"yd2",@"yd3",@"yd4",@"yd5"];
        if (IS_IPHONE_X) {
            arr = @[@"yd1_X",@"yd2_X",@"yd3_X",@"yd4_X",@"yd5_X"];
        }
        //显示新特性，即引导页
        NSMutableArray *imageNameArr = arr.mutableCopy;
        XLJNewFetureController *newFeture = [[XLJNewFetureController alloc]initWithNSArray:imageNameArr withButtonSize:CGSizeMake(125, 35) withButtonTitle:@"立即体验" withButtonImage:@"" withButtonTitleColor:ThemeColor withButtonHeight:0.8 withViewController:navi];
        self.window.rootViewController = newFeture;
    }
    else{
        self.window.rootViewController = navi;
        
    }
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
    
   // UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment[(UIOffsetMake(-100, 0), for: .default)
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-[UIScreen mainScreen].bounds.size.width, -[UIScreen mainScreen].bounds.size.height) forBarMetrics:UIBarMetricsDefault];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if(self.isFull){
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }

    
    
}

@end
