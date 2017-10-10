//
//  LoginViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/5.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "BaseNaviViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNaviBar];
    [self adjustFrame];
    // Do any additional setup after loading the view from its nib.
}


- (void)adjustFrame{
    [self.phoneView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.07 / 2 boardColor:nil boardWidth:0];
    [self.pwdView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.07 / 2 boardColor:nil boardWidth:0];
    [self.loginView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.077 / 2 boardColor:nil boardWidth:0];
}
- (IBAction)forgetPwd:(UIButton *)sender {
    RegisterViewController *registerVC = [RegisterViewController new];
    registerVC.type = 1;
    registerVC.block = ^(NSDictionary *dic) {
        self.phoneTextField.text = dic[@"phone"];
        self.pwdTextField.text = dic[@"pwd"];
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)registe:(UIButton *)sender {
    RegisterViewController *registerVC = [RegisterViewController new];
    registerVC.type = 0;
    registerVC.block = ^(NSDictionary *dic) {
        self.phoneTextField.text = dic[@"phone"];
        self.pwdTextField.text = dic[@"pwd"];
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)login:(UIButton *)sender {
    if([self cheakPhoneNumber:self.phoneTextField.text]){
        if([self cheakPwd:self.pwdTextField.text]){
            //登录接口
            NSString *mdPws = [KRBaseTool md5:self.pwdTextField.text];
            [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/member/login/doLogin.do" params:@{@"mobile":self.phoneTextField.text,@"password":mdPws} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
                if (showdata == nil) {
                    return ;
                }
                NSLog(@"%@",showdata);
                HomeViewController *homeVC = [HomeViewController new];
                BaseNaviViewController *navi = [[BaseNaviViewController alloc] initWithRootViewController:homeVC];
                self.view.window.rootViewController = navi;
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] setObject:showdata forKey:@"userInfo"];
                [[KRUserInfo sharedKRUserInfo] setValuesForKeysWithDictionary:showdata];
            }];
        }
        else{
            [self showHUDWithText:@"密码输入错误!"];
        }
    }
    else{
        [self showHUDWithText:@"手机号输入错误!"];
    }
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
