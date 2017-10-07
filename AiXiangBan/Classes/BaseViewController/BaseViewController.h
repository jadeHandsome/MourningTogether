//
//  BaseViewController.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//隐藏导航栏
- (void)hideNaviBar;
- (void)showNaviBar;
//pop退出
- (void)popOut;
//NSUserDefaults存
- (void)saveToUserDefaultsWithKey:(NSString *)key Value:(id)value;
//NSUserDefaults取
- (id)getFromDefaultsWithKey:(NSString *)key;
//检查是否是手机号
- (BOOL)cheakPhoneNumber:(NSString *)phoneNum;
//检查密码格式
- (BOOL)cheakPwd:(NSString *)pwd;
//显示加载中
- (void)showLoadingHUD;
//显示加载中和文字
- (void)showLoadingHUDWithText:(NSString *)text;
//显示文字
- (void)showHUDWithText:(NSString *)text;
//隐藏加载
- (void)hideHUD;

@end
