//
//  LoginViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/5.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
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
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)registe:(UIButton *)sender {
    RegisterViewController *registerVC = [RegisterViewController new];
    registerVC.type = 0;
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)login:(UIButton *)sender {
    if([self cheakPhoneNumber:self.phoneTextField.text]){
        if([self cheakPwd:self.pwdTextField.text]){
            //登录接口
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
