//
//  RechargeViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    UIButton *rechargeBtn = [[UIButton alloc] init];
    [rechargeBtn setBackgroundColor:ColorRgbValue(0x1cb9cf)];
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
