//
//  MyViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "MyViewController.h"
#import "MineInfoView.h"
#import "MineViewController.h"
#import "AccountViewController.h"
@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    NSArray *data = @[@{@"isImage":@"0",@"title":@"基本信息",@"right":@" "},@{@"isImage":@"0",@"title":@"孝心币",@"right":@""}];
    UIView *centerView = [[UIView alloc]init];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@90);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.view.mas_top).with.offset(10 + navHight);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(centerView, 10, 0, [UIColor clearColor]);
    UIView *temp = centerView;
    for (int i = 0; i < 2; i ++) {
        MineInfoView *infoView = [[MineInfoView alloc]init];
        [infoView setUpWithDic:data[i] withClickHandle:^{
            LRLog(@"点了第%d个",i);
            switch (i) {
                case 0:
                {
                    MineViewController *mine = [MineViewController new];
                    [self.navigationController pushViewController:mine animated:YES];
                }
                    break;
                case 1:
                {
                    AccountViewController *acc = [AccountViewController new];
                    [self.navigationController pushViewController:acc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
        [centerView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView.mas_right);
            make.left.equalTo(centerView.mas_left);
            if (i == 0) {
                make.height.equalTo(@45);
                make.top.equalTo(temp.mas_top);
            } else {
                make.height.equalTo(@45);
                make.top.equalTo(temp.mas_bottom);
            }
        }];
        temp = infoView;
    }
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
