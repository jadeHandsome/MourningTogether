//
//  AddResultViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/11/27.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddResultViewController.h"
#import "WifiTipsViewController.h"
@interface AddResultViewController ()

@end

@implementation AddResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"结果";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(navHight + 55);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    UILabel *SerialNoLabel = [[UILabel alloc] init];
    SerialNoLabel.font = [UIFont systemFontOfSize:15];
    SerialNoLabel.text = self.deviceSerialNo;
    [self.view addSubview:SerialNoLabel];
    [SerialNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textColor = COLOR(215, 127, 74, 1);
    detailLabel.text = @"设备不在线，尚未连接好网络";
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SerialNoLabel.mas_bottom).with.offset(self.needConfigWifi ? 20 : 0);
        make.centerX.equalTo(self.view.mas_centerX);
        if (!self.needConfigWifi) {
            make.height.mas_equalTo(0);
        }
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = ThemeColor;
    [button setTitle:self.needConfigWifi?@"连接网络":@"添加" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(button, 25, 0, ThemeColor);
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@50);
    }];
    
}


- (void)submit:(UIButton *)sender{
    if (self.needConfigWifi) {
        //配置wifi
        WifiTipsViewController *wifiTipVC = [WifiTipsViewController new];
        wifiTipVC.deviceVerifyCode = self.deviceVerifyCode;
        wifiTipVC.deviceSerialNo = self.deviceSerialNo;
        [self.navigationController pushViewController:wifiTipVC animated:YES];
    }
    else{
        //添加
        if(self.deviceVerifyCode != nil)
        {
            [self showLoadingHUDWithText:@"添加中,请稍后..."];
            [EZOPENSDK addDevice:self.deviceSerialNo
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
}

- (void)handleTheError:(NSError *)error
{
    if (!error)
    {
        [self addAction];
    }
    if (error.code == 120010) {
        UIAlertView *retryAlertView = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        retryAlertView.tag = 0xbb;
        [retryAlertView show];
    }
    else if (error.code == 120017 || error.code == 120029)
    {
        [self showHUDWithText:@"设备已被自己添加"];
    }
    else if (error.code == 120022 || error.code == 120024)
    {
        [self showHUDWithText:@"设备已被别人添加"];
    }
    else if (error.code != 0)
    {
        [self showHUDWithText:[NSString stringWithFormat:@"添加失败%ld",error.code]];
    }
}


#pragma mark - UIAlertViewDelgate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0xaa && buttonIndex == 1)
    {
        self.deviceVerifyCode = [alertView textFieldAtIndex:0].text;
        [self showLoadingHUDWithText:@"添加中,请稍后..."];
        [EZOPENSDK addDevice:self.deviceSerialNo
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

- (void)addAction{
    NSDictionary *params = @{@"deviceSerialNo":self.deviceSerialNo,@"deviceName":self.deviceSerialNo,@"deviceType":@(2),@"devicePassword":@"",@"mobile":[KRUserInfo sharedKRUserInfo].mobile,@"elderId":[KRUserInfo sharedKRUserInfo].elderId,@"validateCode":self.deviceVerifyCode};
    [self hideHUD];
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/device/addDevice.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_DEVICE_SUCCESS object:nil];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[NSClassFromString(@"LookViewController") class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    }];
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
