//
//  RestartDeviceViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/11/28.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RestartDeviceViewController.h"
#import "WifiInfoViewController.h"
@interface RestartDeviceViewController ()

@end

@implementation RestartDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重启设备";
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
    detaillabel.text = @"长按设备上的reset键10秒松开，并等待大约30秒直到设备重启完成";
    detaillabel.textAlignment = NSTextAlignmentCenter;
    detaillabel.numberOfLines = 0;
    detaillabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:detaillabel];
    [detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(navHight + 30);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
    }];
    
    UIImageView *deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_reset"]];
    [self.view addSubview:deviceImage];
    [deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detaillabel.mas_bottom).with.offset(25);
        make.width.mas_equalTo(174);
        make.height.mas_equalTo(199);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIButton *firstButton = [[UIButton alloc] init];
    [firstButton setTitle:@"我已经重启好" forState:UIControlStateNormal];
    firstButton.backgroundColor = ThemeColor;
    [firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(firstButton, 25, 0, ThemeColor);
    [firstButton addTarget:self action:@selector(restartDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstButton];
    [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
        make.top.equalTo(deviceImage.mas_bottom).offset(25);
    }];
}

- (void)restartDone:(UIButton *)sender{
    WifiInfoViewController *infoVC = [WifiInfoViewController new];
    [self.navigationController pushViewController:infoVC animated:YES];
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
