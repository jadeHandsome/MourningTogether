//
//  ConfirmViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    LRViewBorderRadius(self.topView, 7.5, 0, [UIColor whiteColor]);
    LRViewBorderRadius(self.confirmBtn, 7.5, 0, [UIColor clearColor]);
    self.topConstraint.constant = navHight + 10;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirm:(UIButton *)sender {
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
