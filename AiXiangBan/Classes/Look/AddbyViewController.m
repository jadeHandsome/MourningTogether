//
//  AddbyViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddbyViewController.h"
#import "CheakPhoneViewController.h"
@interface AddbyViewController ()
@property (nonatomic, strong) UITextField *texifield;
@end

@implementation AddbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入序列号";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)setUp{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(view, 10, 0, [UIColor clearColor]);
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.top.equalTo(self.view).with.offset(navHight + 10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@45);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:16];
    textField.placeholder = @"请输入序列号";
    [view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(10);
        make.top.equalTo(view).with.offset(0);
        make.right.equalTo(view).with.offset(-10);
        make.bottom.equalTo(view).with.offset(0);
    }];
    textField.text = self.deviceSerialNo;
    self.texifield = textField;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = ThemeColor;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(button, 10, 0, ThemeColor);
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@45);
    }];
    
}

- (void)submit:(UIButton *)sender{
    if (self.texifield.text) {
        //萤石
        if (self.deviceType == 2) {
            if(self.deviceVerifyCode != nil)
            {
                [self showLoadingHUDWithText:@"添加中,请稍后..."];
                [EZOPENSDK addDevice:self.texifield.text
                          verifyCode:self.deviceVerifyCode
                          completion:^(NSError *error) {
                              [self hideHUD];
                              [self handleTheError:error];
                          }];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入设备验证码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                alertView.tag = 0xaa;
                [alertView show];
            }
        }
        else{
            CheakPhoneViewController *cheakPhone = [CheakPhoneViewController new];
            cheakPhone.deviceType = self.deviceType;
            cheakPhone.deviceSerialNo = self.texifield.text;
            [self.navigationController pushViewController:cheakPhone animated:YES];
        }
    }
    else{
        [self showHUDWithText:@"设备号不能为空"];
    }
}

- (void)handleTheError:(NSError *)error
{
    if (!error)
    {
        CheakPhoneViewController *cheakPhone = [CheakPhoneViewController new];
        cheakPhone.deviceType = self.deviceType;
        cheakPhone.deviceVerifyCode = self.deviceVerifyCode;
        cheakPhone.deviceSerialNo = self.texifield.text;
        [self.navigationController pushViewController:cheakPhone animated:YES];
        return;
    }
    if (error.code == 105002) {
        UIAlertView *retryAlertView = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        retryAlertView.tag = 0xbb;
        [retryAlertView show];
    }
    else if (error.code == 105000)
    {
        [self showLoadingHUDWithText:@"设备已被自己添加"];
    }
    else if (error.code == 105001)
    {
        [self showLoadingHUDWithText:@"设备已被别人添加"];
    }
}

#pragma mark - UIAlertViewDelgate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0xaa && buttonIndex == 1)
    {
        self.deviceSerialNo = [alertView textFieldAtIndex:0].text;
        
        [self showLoadingHUDWithText:@"添加中,请稍后..."];
        [EZOPENSDK addDevice:self.texifield.text
                  verifyCode:self.deviceVerifyCode
                  completion:^(NSError *error) {
                      [self hideHUD];
                      [self handleTheError:error];
                  }];
    }
    else if (alertView.tag == 0xbb && buttonIndex == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入设备验证码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alertView.tag = 0xaa;
        [alertView show];
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