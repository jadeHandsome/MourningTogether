//
//  HeartRateViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HeartRateViewController.h"

@interface HeartRateViewController ()

@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"心率";
    
    // Do any additional setup after loading the view.
}

- (void)requestData{
    NSDictionary *params = @{};
    [KRMainNetTool sharedKRMainNetTool];
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
