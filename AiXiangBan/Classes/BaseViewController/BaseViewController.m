//
//  BaseViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorRgbValue(0xFFFFFF);
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

#pragma mark ----- 隐藏导航栏
- (void)hideNaviBar{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)showNaviBar{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; 
}

#pragma  mark ----- pop退出
- (void)popOut{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popOutAction)];
}

- (void)popOutAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  -------- userDefaults ---------
- (void)saveToUserDefaultsWithKey:(NSString *)key Value:(id)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getFromDefaultsWithKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma  mark   -------- 常用的正则判断
//手机号
- (BOOL)cheakPhoneNumber:(NSString *)phoneNum{
    return [self NSRegularExpressionWithExpression:@"^1[3|4|5|7|8][0-9]\\d{8}$" AndCheakStr:phoneNum];
}
//检查密码格式6~16位
- (BOOL)cheakPwd:(NSString *)pwd{
    if(pwd){
        if(pwd.length >= 6 && pwd.length <= 16){
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

- (BOOL)NSRegularExpressionWithExpression:(NSString *)Expression AndCheakStr:(NSString *)cheakStr{
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Expression];
    return [Predicate evaluateWithObject:cheakStr];
}

#pragma mark ----------- MBProgressHUD ----------------
- (void)showLoadingHUD{
    [self showLoadingHUDWithText:nil];
}

- (void)showLoadingHUDWithText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    if (text != nil) {
        hud.label.text = text;
    }
}

- (void)showHUDWithText:(NSString *)text{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1.0f];
}

- (void)hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
