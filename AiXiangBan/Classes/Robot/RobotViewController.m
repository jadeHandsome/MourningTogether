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
@property (nonatomic, strong) NSMutableArray *allRobot;//附近的所有机器人
@property (nonatomic, strong) UIScrollView *contentScr;
@end

@implementation RobotViewController
{
    NSInteger count;
}
- (NSMutableArray *)allRobot {
    if (!_allRobot) {
        _allRobot = [NSMutableArray array];
    }
    return _allRobot;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    self.navigationItem.title = @"机器人列表";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    
}
- (void)viewDidAppear:(BOOL)animated {
    _contentScr.contentOffset = CGPointMake(0, 0);
}
- (void)add {
    AddRobotViewController *add = [[AddRobotViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}
- (void)getRobotInfo {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/device/getDeviceList.do" params:@{@"deviceType":@"3",@"offset":@(count),@"size":@"20"} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        NSLog(@"%@",showdata);
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in showdata[@"deviceList"]) {
            if (self.elderId) {
                if ([dic[@"elderId"] isEqualToString:self.elderId]) {
                    if ([dic[@"devicePower"] integerValue] == 1) {
                        [array addObject:dic];
                    }
                    
                }
            } else {
                if ([dic[@"elderId"] isEqualToString:[KRUserInfo sharedKRUserInfo].elderId]) {
                    if ([dic[@"devicePower"] integerValue] == 1) {
                        [array addObject:dic];
                    }
                    
                }
            }
        }
        
        [self.allRobot addObjectsFromArray:array];
        
        [self setUP];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [self loadR];
    //[self getRobotInfo];
}
- (void)setUP {
    for (UIView *sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
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
    UIScrollView *contentScr = [[UIScrollView alloc]init];
    [self.view addSubview:contentScr];
    [contentScr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
    }];
    CGFloat f = 55 * self.allRobot.count;
    if (f < SCREENH_HEIGHT - navHight) {
        f = SCREENH_HEIGHT - navHight;
    }
    contentScr.contentSize = CGSizeMake(0, f);
    _contentScr = contentScr;
    [KRBaseTool tableViewAddRefreshHeader:contentScr withTarget:self refreshingAction:@selector(loadR)];
    [KRBaseTool tableViewAddRefreshFooter:contentScr withTarget:self refreshingAction:@selector(loadmore)];
    UIView *centerView = [[UIView alloc]init];
    [contentScr addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(55 * self.allRobot.count));
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(contentScr.mas_top).with.offset(10);
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
    

}
- (void)loadR {
    count = 0;
    [self.allRobot removeAllObjects];
    [self getRobotInfo];
}
- (void)loadmore {
    count = self.allRobot.count;
    [self getRobotInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
