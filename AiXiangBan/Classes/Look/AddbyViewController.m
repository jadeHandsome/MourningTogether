//
//  AddbyViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddbyViewController.h"
#import "CheakPhoneViewController.h"
#import "AddResultViewController.h"
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
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(10);
        make.top.equalTo(view).with.offset(0);
        make.right.equalTo(view).with.offset(-10);
        make.bottom.equalTo(view).with.offset(0);
    }];
    textField.text = self.deviceSerialNo;
    self.texifield = textField;
    if (self.deviceType == 1) {
        textField.userInteractionEnabled = NO;
    }
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = ThemeColor;
    [button setTitle:@"下一步" forState:UIControlStateNormal];
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
        if (self.deviceType == 2) {
            [self showLoadingHUDWithText:nil];
            [EZOPENSDK probeDeviceInfo:self.texifield.text completion:^(EZProbeDeviceInfo *deviceInfo, NSError *error) {
                if (deviceInfo)
                {
                    [self hideHUD];
                    AddResultViewController *resultVC = [[AddResultViewController alloc] init];
                    resultVC.deviceSerialNo = self.texifield.text;
                    resultVC.deviceVerifyCode = self.deviceVerifyCode;
                    [self.navigationController pushViewController:resultVC animated:YES];
                }
                else if (error.code == EZ_HTTPS_DEVICE_ADDED_MYSELF)
                {
                    [self showHUDWithText:@"您已添加过此设备"];
                }
                else if (error.code == EZ_HTTPS_DEVICE_ONLINE_IS_ADDED ||
                         error.code == EZ_HTTPS_DEVICE_OFFLINE_IS_ADDED)
                {
                    [self showHUDWithText:@"此设备已被别人添加"];
                }
                else if (error.code == EZ_HTTPS_DEVICE_OFFLINE_NOT_ADDED ||
                         error.code == EZ_HTTPS_DEVICE_NOT_EXISTS)
                {
                    [self hideHUD];
                    //配置wifi
                    AddResultViewController *resultVC = [[AddResultViewController alloc] init];
                    resultVC.deviceSerialNo = self.deviceSerialNo;
                    resultVC.deviceVerifyCode = self.deviceVerifyCode;
                    resultVC.needConfigWifi = YES;
                    [self.navigationController pushViewController:resultVC animated:YES];
                }
                else
                {
                    [self showHUDWithText:@"网络异常,请重试"];
                }
            }];
        }
        else{
            [self addAction];
        }
    }
    else{
        [self showHUDWithText:@"设备号不能为空"];
    }

}



- (void)addAction{
    NSMutableDictionary *params = @{@"deviceSerialNo":self.texifield.text,@"deviceName":self.texifield.text,@"deviceType":@(self.deviceType),@"devicePassword":@"",@"mobile":[KRUserInfo sharedKRUserInfo].mobile,@"elderId":[KRUserInfo sharedKRUserInfo].elderId,@"validateCode":@""}.mutableCopy;
    if (self.deviceType == 2) {
        params[@"validateCode"] = self.deviceVerifyCode;
    }
    [self hideHUD];
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/device/addDevice.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_DEVICE_SUCCESS object:nil];
            NSInteger count = self.navigationController.viewControllers.count - 3;
            UIViewController *viewCtl = self.navigationController.viewControllers[count];
            [self.navigationController popToViewController:viewCtl animated:YES];
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
