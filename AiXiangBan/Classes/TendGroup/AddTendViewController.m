//
//  AddTendViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddTendViewController.h"
#import "AddTendView.h"
#import "ChooseOlderViewController.h"
#import "ChooseDeviceViewController.h"
#import "RobotViewController.h"
#import "LocationViewController.h"
#import "NoWatchViewController.h"
#import "LookViewController.h"
@interface AddTendViewController ()

@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) NSDictionary *myData;
@end

@implementation AddTendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加看护群组";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}
- (void)viewDidAppear:(BOOL)animated {
    self.mainScroll.contentOffset = CGPointMake(0, 0);
}
- (void)loadData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/family/getFamilyMemberList.do" params:@{@"familyId":self.famliID} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        self.myData = [showdata copy];
        NSMutableArray *eq = [NSMutableArray array];
        for (NSDictionary *dic in showdata[@"familyElderList"]) {
            
            [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:@"mgr/family/getElderDeviceList.do" params:@{@"elderId":dic[@"familyElderId"],@"offset":@0,@"size":@20} withModel:nil complateHandle:^(id showdata1, NSString *error) {
                if (showdata1 == nil) {
                    return ;
                }
                NSMutableDictionary *mut = [NSMutableDictionary dictionary];
                NSArray *device = [KRBaseTool getDeviceDataWithElderId:dic[@"familyElderId"] andHomeId:self.famliID];
                NSString *look = @"云医时代1-85";
                NSString *robot = @"云医时代1-87";
                NSString *location = @"云医时代1-89";
                mut[@"hasLoc"] = @0;
                mut[@"hasLook"] = @0;
                mut[@"hasRobot"] = @0;
                for (NSDictionary *subDic in showdata1[@"deviceList"]) {
                    if ([subDic[@"deviceType"] integerValue] == 1) {
                        location = @"云医时代1-93";
                        mut[@"hasLoc"] = subDic[@"deviceSerialNo"];
                    }
                    if ([subDic[@"deviceType"] integerValue] == 2) {
                        look = @"云医时代1-91";
                        mut[@"hasLook"] = @1;
                        
                    }
                    if ([subDic[@"deviceType"] integerValue] == 3) {
                        robot = @"云医时代1-92";
                        mut[@"hasRobot"] = @1;
                    }
                }
                
                if (!device) {
                    device = @[@{@"eqName":@"位置",@"eqImage":location},@{@"eqName":@"看看",@"eqImage":look},@{@"eqName":@"机器人",@"eqImage":robot},@{@"eqName":@"闯入检测",@"eqImage":@"云医时代1-86"},@{@"eqName":@"血糖检测",@"eqImage":@"云医时代1-88"},@{@"eqName":@"烟雾报警",@"eqImage":@"云医时代1-90"}];
                } else {
                    
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSDictionary *subDevice in device) {
                        if ([subDevice[@"eqName"] isEqualToString:@"位置"]) {
                            [tempArray addObject:@{@"eqName":@"位置",@"eqImage":location}];
                            continue;
                        }
                        if ([subDevice[@"eqName"] isEqualToString:@"看看"]) {
                            [tempArray addObject:@{@"eqName":@"看看",@"eqImage":look}];
                            continue;
                        }
                        if ([subDevice[@"eqName"] isEqualToString:@"机器人"]) {
                            [tempArray addObject:@{@"eqName":@"机器人",@"eqImage":robot}];
                            continue;
                        }
                        [tempArray addObject:subDevice];
                        
                    }
                    device = [tempArray copy];
                }
                mut[@"equipment"] = device;
                mut[@"oldDic"] = dic;
                [eq addObject:mut];
                if (eq.count == [showdata[@"familyElderList"] count]) {
                    NSMutableDictionary *old = [NSMutableDictionary dictionary];
                    old[@"title"] = @"老人";
                    old[@"child"] = [eq copy];
                    
                    NSMutableArray *lookMan = [NSMutableArray array];
                    NSMutableArray *qinqiMan = [NSMutableArray array];
                    for (NSDictionary *dic in showdata[@"familyOtherList"]) {
                        if ([dic[@"contactType"] integerValue] == 1) {
                            [lookMan addObject:dic];
                        } else {
                            [qinqiMan addObject:dic];
                        }
                        
                    }
                    NSMutableDictionary *lookDic = [NSMutableDictionary dictionary];
                    lookDic[@"title"] = @"监护人";
                    lookDic[@"child"] = [lookMan copy];
                    
                    NSMutableDictionary *qinqiDic = [NSMutableDictionary dictionary];
                    qinqiDic[@"title"] = @"亲属邻里";
                    qinqiDic[@"child"] = [qinqiMan copy];
                    self.alltend = @[old,lookDic,qinqiDic];
                    [self setUp];
                }
            }];
            
            
            
        }
        
    }];
}
- (void)setUp {
    for (UIView *sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
    self.mainScroll = [[UIScrollView alloc]init];
    [self.view addSubview:self.mainScroll];
    self.mainScroll.backgroundColor = [UIColor clearColor];
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    //self.mainScroll.contentSize = CGSizeMake(0, 126 * self.alltend.count);
    UIView *temp = self.mainScroll;
    CGFloat height = 115;
    
    for (int i = 0; i < self.alltend.count; i ++) {
        if ( i == 0) {
            CGFloat h = 0;
            CGSize size = [UIImage imageNamed:@"云医时代1-100"].size;
            for (int j = 0; j < [self.alltend[0][@"child"] count]; j ++) {
                h += size.height + 20 + 55 + (([self.alltend[0][@"child"][j][@"equipment"] count] + 2)/3) * 15 + (2 + [self.alltend[0][@"child"][j][@"equipment"] count])/3 * 20 + 20 ;
            }
            height = 90 + h;
            self.mainScroll.contentSize = CGSizeMake(0, 40 + 2 * 115 + h + 90 + 65);
        } else {
            height = 120;
        }
        AddTendView *tend = [[AddTendView alloc]init];
        [self.mainScroll addSubview:tend];
        [tend mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(temp.mas_top).with.offset(10);
            } else {
                make.top.equalTo(temp.mas_bottom).with.offset(10);
            }
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.height.equalTo(@(height));
        }];
        [tend setAddTendWith:self.alltend[i]];
        __weak typeof(self) weakSelf = self;
        tend.block = ^(NSInteger tag, BOOL isAdd) {
            
            ChooseOlderViewController *choose = [[ChooseOlderViewController alloc]init];
            choose.type = tag;
            choose.oldData = weakSelf.myData;
            choose.isDelet = isAdd;
            [weakSelf.navigationController pushViewController:choose animated:YES];
            
        };
        tend.btnBlock = ^(NSInteger type, NSString *elderId,NSInteger has) {
            switch (type) {
                case 1:
                {
                    [weakSelf addDeviceWith:elderId];
                }
                    break;
                case 2:
                {
                    [weakSelf gotoLocation:elderId has:has];
                }
                    break;
                case 3:
                {
                    [weakSelf gotoLook:elderId has:has];
                }
                    break;
                case 4:
                {
                    [weakSelf gotoRobot:elderId has:has];
                }
                    break;
                    
                default:
                    break;
            }
        };
        temp = tend;
        
    }
    UIButton *deletBtn = [[UIButton alloc]init];
    [self.mainScroll addSubview:deletBtn];
    [deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@45);
    }];
    deletBtn.backgroundColor =LRRGBColor(211, 80, 70);
    [deletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deletBtn setTitle:@"删除" forState:UIControlStateNormal];
    LRViewBorderRadius(deletBtn, 5, 0, [UIColor clearColor]);
    [deletBtn addTarget:self action:@selector(delectClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
//添加设备
- (void)addDeviceWith:(NSString *)elderId {
    ChooseDeviceViewController *dev = [[ChooseDeviceViewController alloc]init];
    dev.familyId = self.famliID;
    dev.elderId = elderId;
    [self.navigationController pushViewController:dev animated:YES];
}
//去位置
- (void)gotoLocation:(NSString *)elderId has:(NSInteger)has{
    NSLog(@"去位置");
    [[KRUserInfo sharedKRUserInfo] setElderId:elderId];
    if (has) {
        LocationViewController *loc = [[LocationViewController alloc]init];
        [[KRUserInfo sharedKRUserInfo] setDeviceId:[NSString stringWithFormat:@"%ld",has]];
        [self.navigationController pushViewController:loc animated:YES];
    } else {
        NoWatchViewController *no = [[NoWatchViewController alloc]init];
        
        [self.navigationController pushViewController:no animated:YES];
    }
    
}
//去看看
- (void)gotoLook:(NSString *)elderId  has:(NSInteger)has{
    NSLog(@"去看看");
    [[KRUserInfo sharedKRUserInfo] setElderId:elderId];
    LookViewController *look = [[LookViewController alloc]init];
    [self.navigationController pushViewController:look animated:YES];
    
}
//去机器人
- (void)gotoRobot:(NSString *)elderId  has:(NSInteger)has{
    NSLog(@"去机器人");
    [[KRUserInfo sharedKRUserInfo] setElderId:elderId];
    RobotViewController *robot = [[RobotViewController alloc]init];
    [self.navigationController pushViewController:robot animated:YES];
}
//删除
- (void)delectClick {
    //删除
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除联系人" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
            [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/family/deleteFamily.do" params:@{@"familyId":self.famliID} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
                if (showdata == nil) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"删除成功"];
            }];
        
        
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [controller addAction:action];
    [controller addAction:action1];
    
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
