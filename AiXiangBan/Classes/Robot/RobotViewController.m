//
//  RobotViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RobotViewController.h"
#import "RobotView.h"
#import "ControllRobotViewController.h"
#import "AddRobotViewController.h"
@interface RobotViewController ()
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) NSArray *allRobot;//附近的所有机器人
@end

@implementation RobotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"机器人列表";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    
    
    
//    self.allRobot = @[@{@"name":@"小胖",@"ID":@"SM1234215"},@{@"name":@"小胖",@"ID":@"SM1234215"},@{@"name":@"小胖",@"ID":@"SM1234215"},@{@"name":@"小胖",@"ID":@"SM1234215"},@{@"name":@"小胖",@"ID":@"SM1234215"},@{@"name":@"小胖",@"ID":@"SM1234215"}];
    [self getRobotInfo];
    
}
- (void)add {
    AddRobotViewController *add = [[AddRobotViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}
- (void)getRobotInfo {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/device/getDeviceList.do" params:@{@"deviceType":@"3",@"offset":@"0",@"size":@"20"} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        NSLog(@"%@",showdata);
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in showdata[@"deviceList"]) {
            if (self.elderId) {
                if ([dic[@""] isEqualToString:self.elderId]) {
                    [array addObject:dic];
                }
            } else {
                if ([dic[@""] isEqualToString:[KRUserInfo sharedKRUserInfo].elderId]) {
                    [array addObject:dic];
                }
            }
        }
        self.allRobot = [showdata[@"deviceList"] copy];
        
        [self setUP];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    
}
- (void)setUP {
    if (self.allRobot.count == 0) {
        UILabel *nullLabel = [[UILabel alloc]init];
        [self.view addSubview:nullLabel];
        [nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).with.offset(navHight);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        }];
        nullLabel.text = @"暂无机器人";
        nullLabel.textAlignment = NSTextAlignmentCenter;
        nullLabel.textColor = LRRGBColor(143, 143, 143);
        //return;
    }
    self.mainScroll = [[UIScrollView alloc]init];
    
    UIView *centerView = [[UIView alloc]init];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(55 * self.allRobot.count));
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.view.mas_top).with.offset(10 + navHight);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(centerView, 10, 0, [UIColor clearColor]);
    UIView *temp = centerView;
    for (int i = 0; i < self.allRobot.count; i ++) {
        RobotView *infoView = [[RobotView alloc]init];
        __weak typeof(self) weakSelf = self;
        [infoView setUpWithDic:self.allRobot[i] withClickHandle:^(id responseObject) {
            NSLog(@"%@",responseObject);
            ControllRobotViewController *ct = [ControllRobotViewController new];
            ct.robotId = responseObject[@"deviceSerialNo"];
            [weakSelf.navigationController pushViewController:ct animated:YES];
        }];
//        [RobotView setUpWithDic:self.allRobot[i] withClickHandle:^{
//            LRLog(@"点了第%d个",i);
//            AboutUsViewController *about = [[AboutUsViewController alloc]init];
//            if (i == 0) {
//                about.title = @"关于我们";
//                [self.navigationController pushViewController:about animated:YES];
//
//            } else if (i == 1) {
//                about.title = @"服务协议";
//                [self.navigationController pushViewController:about animated:YES];
//            } else if (i == 3) {
//                //修改密码
//                ReparePwsViewController *repare = [[ReparePwsViewController alloc]init];
//                [self.navigationController pushViewController:repare animated:YES];
//            }
//
//
//        }];
        [centerView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView.mas_right);
            make.left.equalTo(centerView.mas_left);
            make.height.equalTo(@55);
            if (i == 0) {
                
                make.top.equalTo(temp.mas_top);
            } else {
                
                make.top.equalTo(temp.mas_bottom);
            }
        }];
        temp = infoView;
    }
    
//    UIButton *search = [[UIButton alloc]init];
//    [self.view addSubview:search];
//    [search mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).with.offset(10);
//        make.right.equalTo(self.view.mas_right).with.offset(-10);
//        make.height.equalTo(@45);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
//    }];
//    [search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    search.backgroundColor = LRRGBColor(31, 174, 198);
//    [search setTitle:@"搜索" forState:UIControlStateNormal];
//    LRViewBorderRadius(search, 5, 0, [UIColor clearColor]);
//    [search addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
