//
//  NoWatchViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "NoWatchViewController.h"
#import "AddWatchViewController.h"

@interface NoWatchViewController ()

@end

@implementation NoWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";
    
    [self setUpZero];
}
//没有手表
- (void)setUpZero {
    for (UIView *sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
    UILabel *centerLabel = [[UILabel alloc]init];
    [self.view addSubview:centerLabel];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    centerLabel.textColor = [UIColor blackColor];
    centerLabel.text = @"点击添加手表";
    centerLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(centerLabel.mas_bottom).with.offset(25);
        make.height.equalTo(@45);
    }];
    addBtn.backgroundColor = LRRGBColor(85, 183, 204);
    LRViewBorderRadius(addBtn, 5, 0, [UIColor clearColor]);
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"云医时代1-99"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(centerLabel.mas_top).with.offset(-25);
    }];
}
- (void)addBtnClick {
    AddWatchViewController *addWatch = [[AddWatchViewController alloc]init];
    [self.navigationController pushViewController:addWatch animated:YES];
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
