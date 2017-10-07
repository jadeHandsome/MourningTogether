//
//  RepareInfoViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RepareInfoViewController.h"

@interface RepareInfoViewController ()

@end

@implementation RepareInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    [self setUP];
}
- (void)setUP {
    UIView *contentView = [[UIView alloc]init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight + 10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@50);
    }];
    LRViewBorderRadius(contentView, 5, 0, [UIColor clearColor]);
    contentView.backgroundColor = [UIColor whiteColor];
    
    UITextField *infotext = [[UITextField alloc]init];
    [contentView addSubview:infotext];
    [infotext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right);
        make.top.equalTo(contentView.mas_top);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    infotext.placeholder = self.title;
    infotext.textColor = LRRGBColor(200, 200, 200);
    
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
