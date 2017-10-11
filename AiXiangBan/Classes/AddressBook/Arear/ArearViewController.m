//
//  ArearViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/11.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ArearViewController.h"

@interface ArearViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *arearTableView;
@end

@implementation ArearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUP];
}
- (void)setUP {
    self.arearTableView = [[UITableView alloc]init];
    [self.view addSubview:self.arearTableView];
    [self.arearTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.arearTableView.delegate = self;
    self.arearTableView.dataSource = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
