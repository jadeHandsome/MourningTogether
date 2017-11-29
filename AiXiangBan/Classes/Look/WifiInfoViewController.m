//
//  WifiInfoViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/11/28.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "WifiInfoViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "WifiConfigViewController.h"
@interface WifiInfoViewController ()
@property (nonatomic, strong) UITextField *nameTextfield;
@property (nonatomic, strong) UITextField *pwdTextfield;
@end

@implementation WifiInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第二步，连接WiFi";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)setUp{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wifi_bg"]];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(navHight);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"如果你使用的是双频路由器，请不要让摄像机连接5G频段的Wi-Fi";
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.numberOfLines = 0;
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(navHight + 15);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    UIView *nameContainer = [[UIView alloc] init];
    nameContainer.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(nameContainer, 10, 1, COLOR(218, 218, 218, 1));
    [self.view addSubview:nameContainer];
    [nameContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"网络";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameContainer addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(nameContainer);
        make.width.mas_equalTo(60);
    }];
    UITextField *nameTextfiled = [[UITextField alloc] init];
    nameTextfiled.userInteractionEnabled = NO;
    self.nameTextfield = nameTextfiled;
    [nameContainer addSubview:nameTextfiled];
    [nameTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(nameContainer);
        make.left.equalTo(nameLabel.mas_right);
    }];
    
    NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
    for (NSString *ifnam in interfaces)
    {
        NSDictionary *info = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam));
        nameTextfiled.text = info[@"SSID"];
        break;
    }
    

    UIView *pwdContainer = [[UIView alloc] init];
    pwdContainer.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(pwdContainer, 10, 1, COLOR(218, 218, 218, 1));
    [self.view addSubview:pwdContainer];
    [pwdContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameContainer.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
    }];
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.text = @"密码";
    pwdLabel.textAlignment = NSTextAlignmentCenter;
    [pwdContainer addSubview:pwdLabel];
    [pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(pwdContainer);
        make.width.mas_equalTo(60);
    }];
    UITextField *pwdTextfiled = [[UITextField alloc] init];
    pwdTextfiled.placeholder = @"请输入密码";
    self.pwdTextfield = pwdTextfiled;
    [pwdContainer addSubview:pwdTextfiled];
    [pwdTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(pwdContainer);
        make.left.equalTo(pwdLabel.mas_right);
    }];
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.backgroundColor = ThemeColor;
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(nextButton, 25, 0, ThemeColor);
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(pwdContainer.mas_bottom).offset(25);
    }];
    
//
}

- (void)next:(UIButton *)sender{
    WifiConfigViewController *configVC = [WifiConfigViewController new];
    configVC.deviceVerifyCode = self.deviceVerifyCode;
    configVC.deviceSerialNo = self.deviceSerialNo;
    configVC.ssid = self.nameTextfield.text;
    configVC.password = self.pwdTextfield.text;
    [self.navigationController pushViewController:configVC animated:YES];
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
