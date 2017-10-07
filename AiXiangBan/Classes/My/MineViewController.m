//
//  MineViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/6.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "MineViewController.h"
#import "MineInfoView.h"
@interface MineViewController ()
@property (nonatomic, strong) UIScrollView *mineScrollView;//信息的scrollView
@property (nonatomic, strong) NSArray *allData;//所有的个人信息
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.allData = @[@{@"isImage":@"1",@"title":@"头像",@"right":@""},@{@"isImage":@"0",@"title":@"姓名",@"right":@"周春仕"},@{@"isImage":@"0",@"title":@"电话",@"right":@"18888888888"},@{@"isImage":@"0",@"title":@"性别",@"right":@"女"},@{@"isImage":@"0",@"title":@"年龄",@"right":@"80"},@{@"isImage":@"0",@"title":@"体重",@"right":@"80KG"},@{@"isImage":@"0",@"title":@"身高",@"right":@"188"}];
    [self setUP];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"云医时代-53"] style:UIBarButtonItemStyleDone target:self action:@selector(settingClick)];
    
}
- (void)settingClick {
    
}
- (void)setUP {
    self.mineScrollView = [[UIScrollView alloc]init];
    self.mineScrollView.contentSize = CGSizeMake(0, 330);
    [self.view addSubview:self.mineScrollView];
    [self.mineScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    UIView *centerView = [[UIView alloc]init];
    [self.mineScrollView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@330);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.mineScrollView.mas_top).with.offset(10);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(centerView, 10, 0, [UIColor clearColor]);
    UIView *temp = centerView;
    for (int i = 0; i < 7; i ++) {
        MineInfoView *infoView = [[MineInfoView alloc]init];
        [infoView setUpWithDic:self.allData[i] withClickHandle:^{
            LRLog(@"点了第%d个",i);
        }];
        [centerView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView.mas_right);
            make.left.equalTo(centerView.mas_left);
            if (i == 0) {
                make.height.equalTo(@60);
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
