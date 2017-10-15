//
//  RegisterViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/5.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RegisterViewController.h"
#import "HYTimerButton.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *repeatPwdView;
@property (weak, nonatomic) IBOutlet UIView *nextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPwdField;
@property (weak, nonatomic) IBOutlet UIView *codeContainer;
@property (weak, nonatomic) IBOutlet UIButton *NextBtn;
@property (nonatomic, strong) HYTimerButton *codeBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNaviBar];
    [self adjustFrame];
    [self addCodeBtn];
    // Do any additional setup after loading the view from its nib.
}

- (void)adjustFrame{
    [self.phoneView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.07 / 2 boardColor:nil boardWidth:0];
    [self.codeView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.07 / 2 boardColor:nil boardWidth:0];
    [self.pwdView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.07 / 2 boardColor:nil boardWidth:0];
    [self.nextView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.077 / 2 boardColor:nil boardWidth:0];
    [self.codeContainer.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.044 / 2 boardColor:nil boardWidth:0];
    [self.repeatPwdView.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.07 / 2 boardColor:nil boardWidth:0];
    if(self.type == VC_TYPE_REGISTER){
        [self.NextBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
    else{
        [self.NextBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    }
}

- (void)addCodeBtn{
    
    self.codeBtn = [[HYTimerButton alloc] initWithFrame:CGRectMake(0, 0 , SIZEWIDTH * 0.225, SIZEHEIGHT * 0.044) title:@"获取验证码" countDownTime:60];
    self.codeBtn.backgroundColor = [UIColor whiteColor];
    [self.codeBtn setTitleColor:ThemeColor];
    [self.codeBtn setCountDownTitleColor:ThemeColor];
    [self.codeBtn setDjTitleColor:ThemeColor];
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.codeContainer addSubview:self.codeBtn];
}

- (void)getCode{
    if (![self cheakPhoneNumber:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"手机号码输入有误" toView:self.view];
        return;
    }
    NSString *type = @"1";
    if (self.type == VC_TYPE_REGISTER) {
        type = @"1";
    } else {
        type = @"2";
    }
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/member/register/getSmsCode.do" params:@{@"mobile":self.phoneTextField.text,@"type":type} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        [MBProgressHUD showSuccess:@"验证码发送成功" toView:self.view];
        [self.codeBtn start];
    }];
    
}

- (IBAction)next:(UIButton *)sender {
    if([self cheakPhoneNumber:self.phoneTextField.text]){
        if(self.codeTextField.text && self.codeTextField.text.length == 6){
            if([self cheakPwd:self.pwdTextField.text]){
                if ([self cheakPwd:self.repeatPwdField.text] && self.repeatPwdField.text == self.pwdTextField.text) {
                    [self request];
                }
                else{
                    [self showHUDWithText:@"两次密码不一致!"];
                }
            }
            else{
                [self showHUDWithText:@"密码格式错误!"];
            }
        }
        else{
            [self showHUDWithText:@"验证吗输入错误!"];
        }
    }
    else{
        [self showHUDWithText:@"手机号输入错误!"];
    }
}

- (void)request{
    if(self.type == VC_TYPE_REGISTER){
        //注册
        NSString *mdPws = [KRBaseTool md5:self.pwdTextField.text];
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/member/register/register.do" params:@{@"mobile":self.phoneTextField.text,@"password":mdPws,@"smsCode":self.codeTextField.text} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [MBProgressHUD showSuccess:@"注册成功" toView:self.view.window];
            if (self.block) {
                self.block(@{@"phone":self.phoneTextField.text,@"pwd":self.pwdTextField.text});
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else{
        //找回密码
        NSString *mdPws = [KRBaseTool md5:self.pwdTextField.text];
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/member/register/forgetPassword.do" params:@{@"mobile":self.phoneTextField.text,@"password":mdPws,@"smsCode":self.codeTextField.text} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view.window];
            if (self.block) {
                self.block(@{@"phone":self.phoneTextField.text,@"pwd":self.pwdTextField.text});
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
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
