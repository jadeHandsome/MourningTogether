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
@property (weak, nonatomic) IBOutlet UIView *nextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
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
    [self.codeBtn start];
}

- (IBAction)next:(UIButton *)sender {
    if([self cheakPhoneNumber:self.phoneTextField.text]){
        if(self.codeTextField.text && self.codeTextField.text.length == 4){
            if([self cheakPwd:self.pwdTextField.text]){
                [self request];
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
    }
    else{
        //找回密码
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
