//
//  WifiTipsViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/11/27.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "WifiTipsViewController.h"
#import "RestartDeviceViewController.h"
#import "WifiInfoViewController.h"
@interface WifiTipsViewController ()
{
    BOOL _isRestart;
}

@end

@implementation WifiTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第一步，准备好设备";
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
    
    UILabel *detaillabel = [[UILabel alloc] init];
    detaillabel.text = @"请将设备插上电后大约30秒，直到设备启动完成";
    detaillabel.textAlignment = NSTextAlignmentCenter;
    detaillabel.numberOfLines = 0;
    detaillabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:detaillabel];
    [detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(navHight + 30);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
    }];
    
    UIImageView *deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device"]];
    [self.view addSubview:deviceImage];
    [deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detaillabel.mas_bottom).with.offset(25);
        make.width.mas_equalTo(174);
        make.height.mas_equalTo(199);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIButton *firstButton = [[UIButton alloc] init];
    [firstButton setTitle:@"设备已启动好，且是第一次配置网络" forState:UIControlStateNormal];
    firstButton.backgroundColor = ThemeColor;
    [firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(firstButton, 25, 0, ThemeColor);
    [firstButton addTarget:self action:@selector(ConfigWifi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstButton];
    [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
        make.top.equalTo(deviceImage.mas_bottom).offset(25);
    }];
    
    UIButton *notFirstButton = [[UIButton alloc] init];
    [notFirstButton setTitle:@"这台设备以前配置过网络" forState:UIControlStateNormal];
    notFirstButton.backgroundColor = [UIColor whiteColor];
    [notFirstButton setTitleColor:ThemeColor forState:UIControlStateNormal];
    LRViewBorderRadius(notFirstButton, 25, 1, ThemeColor);
    [notFirstButton addTarget:self action:@selector(reStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notFirstButton];
    [notFirstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
        make.top.equalTo(firstButton.mas_bottom).offset(15);
    }];
}
//配置wifi
- (void)ConfigWifi:(UIButton *)sender{
    WifiInfoViewController *infoVC = [WifiInfoViewController new];
    infoVC.deviceVerifyCode = self.deviceVerifyCode;
    infoVC.deviceSerialNo = self.deviceSerialNo;
    [self.navigationController pushViewController:infoVC animated:YES];
}
//重启设备
- (void)reStart:(UIButton *)sender{
    RestartDeviceViewController *restartVC = [RestartDeviceViewController new];
    restartVC.deviceVerifyCode = self.deviceVerifyCode;
    restartVC.deviceSerialNo = self.deviceSerialNo;
    [self.navigationController pushViewController:restartVC animated:YES];
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
