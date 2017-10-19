//
//  AlarmViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmView.h"
#import "AlarmDetailViewController.h"
@interface AlarmViewController ()
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) NSMutableArray *allAlarm;
@end

@implementation AlarmViewController
{
    NSInteger count;
}
- (NSMutableArray *)allAlarm {
    if (!_allAlarm) {
        _allAlarm = [NSMutableArray array];
    }
    return _allAlarm;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"警报";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    [self loadD];
}
- (void)loadData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/emergency/getEmergencyList.do" params:@{@"offset":@(count),@"size":@30} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        [self.allAlarm addObjectsFromArray:showdata[@"emergencyList"]];
        [self setUp];
    }];
}
- (void)loadD {
    [self.allAlarm removeAllObjects];
    count = 0;
    [self loadData];
}
- (void)loadMore {
    count = self.allAlarm.count;
    [self loadData];
}
- (void)setUp {
    for (UIView *sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
    self.mainScroll = [[UIScrollView alloc]init];
    [KRBaseTool tableViewAddRefreshFooter:self.mainScroll withTarget:self refreshingAction:@selector(loadD)];
    [KRBaseTool tableViewAddRefreshHeader:self.mainScroll withTarget:self refreshingAction:@selector(loadMore)];
    [self.view addSubview:self.mainScroll];
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    self.mainScroll.contentSize = CGSizeMake(0, self.allAlarm.count * 60 + 20);
    UIView *content = [[UIView alloc]init];
    content.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.mainScroll.mas_top).with.offset(10);
        make.height.equalTo(@(self.allAlarm.count * 60));
    }];
    LRViewBorderRadius(content, 5, 0, [UIColor clearColor]);
    UIView *temp = content;
    for (int i = 0; i < self.allAlarm.count; i ++) {
        AlarmView *alarm = [[AlarmView alloc]init];
        [content addSubview:alarm];
        [alarm mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.equalTo(content.mas_left);
            make.right.equalTo(content.mas_right);
            make.height.equalTo(@60);
        }];
        alarm.block = ^(NSDictionary *dic) {
          //跳到警告详情
            AlarmDetailViewController *detail = [[AlarmDetailViewController alloc]init];
            detail.alarmId = dic[@"emergencyId"];
            [self.navigationController pushViewController:detail animated:YES];
        };
        [alarm setUpWith:self.allAlarm[i]];
        temp = alarm;
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
