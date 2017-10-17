//
//  ChooseDeviceViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ChooseDeviceViewController.h"
#import "ChooseDeviceView.h"
@interface ChooseDeviceViewController ()
@property (nonatomic, strong) NSArray *allData;
@property (nonatomic, strong) NSMutableArray *chooseArray;
@end

@implementation ChooseDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.navigationItem.title = @"选择设备";
    
    
    self.allData = @[@{@"eqName":@"位置",@"eqImage":@"云医时代1-28da"},@{@"eqName":@"看看",@"eqImage":@"云医时代1-27da (1)"},@{@"eqName":@"机器人",@"eqImage":@"云医时代1-27da (2)"},@{@"eqName":@"闯入检测",@"eqImage":@"云医时代1-94"},@{@"eqName":@"血糖监测",@"eqImage":@"云医时代1-95"},@{@"eqName":@"烟雾警报",@"eqImage":@"云医时代1-96"}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick)];
    [self setUp];
}
- (void)saveClick {
    NSArray *temp = @[@{@"eqName":@"位置",@"eqImage":@"云医时代1-89"},@{@"eqName":@"看看",@"eqImage":@"云医时代1-85"},@{@"eqName":@"机器人",@"eqImage":@"云医时代1-87"},@{@"eqName":@"闯入检测",@"eqImage":@"云医时代1-86"},@{@"eqName":@"血糖监测",@"eqImage":@"云医时代1-88"},@{@"eqName":@"烟雾警报",@"eqImage":@"云医时代1-90"}];
    NSMutableArray *temp1 = [NSMutableArray array];
    
    for (NSDictionary *dic in self.chooseArray) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        tempDic[@"eqName"] = dic[@"eqName"];
        for (NSDictionary *dic2 in temp) {
            if ([dic2[@"eqName"] isEqualToString:dic[@"eqName"]]) {
                tempDic[@"eqImage"] = dic2[@"eqImage"];
            }
        }
        [temp1 addObject:tempDic];
    }
    [KRBaseTool saveDeviceDataWith:temp1 andElderId:self.elderId andHomeId:self.familyId];
    [self.navigationController popViewControllerAnimated:YES];
}
                                                                                               
                                                                                               
- (void)setUp {
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight + 10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@(45 * 6));
    }];
    NSArray *oldArray = [KRBaseTool getDeviceDataWithElderId:self.elderId andHomeId:self.familyId];
    if (!oldArray) {
        oldArray = @[@{@"eqName":@"位置",@"eqImage":@"云医时代1-28da"},@{@"eqName":@"看看",@"eqImage":@"云医时代1-27da (1)"},@{@"eqName":@"机器人",@"eqImage":@"云医时代1-27da (2)"},@{@"eqName":@"闯入检测",@"eqImage":@"云医时代1-94"},@{@"eqName":@"血糖监测",@"eqImage":@"云医时代1-95"},@{@"eqName":@"烟雾警报",@"eqImage":@"云医时代1-96"}];
    }
    self.chooseArray = [oldArray mutableCopy];
    UIView *temp = contentView;
    for (int i = 0; i < 6; i ++) {
        ChooseDeviceView *views = [[ChooseDeviceView alloc]init];
        [contentView addSubview:views];
        [views mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.right.equalTo(contentView.mas_right);
            if ( i == 0) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.height.equalTo(@45);
            
        }];
        for (NSDictionary *dic in oldArray) {
            if ([dic[@"eqName"] isEqualToString:self.allData[i][@"eqName"]]) {
                views.isChoose = YES;
            }
        }
        views.addBlock = ^(NSDictionary *dic, BOOL isChoose) {
            if (isChoose) {
                [self.chooseArray addObject:dic];
            } else {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dics in self.chooseArray) {
                    if (![dics[@"eqName"] isEqualToString:dic[@"eqName"]]) {
                        [array addObject:dics];
                    }
                }
                self.chooseArray = [array mutableCopy];
                
            }
        };
        [views setUpWith:self.allData[i]];
        temp = views;
        
    }
    LRViewBorderRadius(contentView, 5, 0, [UIColor clearColor]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
