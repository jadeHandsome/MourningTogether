//
//  TendViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TendViewController.h"
#import "TendView.h"
#import "AddTendViewController.h"
#import "ChooseOlderViewController.h"

@interface TendViewController ()
@property (nonatomic, strong) NSMutableArray *alltend;//所有群组的数组
@property (nonatomic, strong) UIScrollView *mainScroll;
@end

@implementation TendViewController
{
    NSInteger refreshCount;
}
- (NSMutableArray *)alltend {
    if (!_alltend) {
        _alltend = [NSMutableArray array];
    }
    return _alltend;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"看护群组";
    refreshCount = 0;
    
}
- (void)viewWillAppear:(BOOL)animated {
    refreshCount = 0;
    [self loadData];
    //[self getTendGropData];
}
- (void)loadData {
    refreshCount = 0;
    [self getTendGropData];
}
- (void)loadMoreData {
    refreshCount = self.alltend.count;
    [self getTendGropData];
}
//获取群组数据
- (void)getTendGropData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/family/getFamilyList.do" params:@{@"offset":@(refreshCount),@"size":@20} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        
        if (refreshCount != 0) {
            NSMutableArray *listArray = [NSMutableArray array];
            
            for (NSDictionary *dic in showdata[@"familyList"]) {
                if ([dic[@"familyId"] isEqualToString:@"3941de33c5ef4900b201b14a7a39758f"]) {
                    continue;
                }
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"old"] = dic[@"familyElderList"];
                param[@"child"] = dic[@"familyOtherList"];
                param[@"familyId"] = dic[@"familyId"];
                [listArray addObject:param];
            }
            [self.alltend addObjectsFromArray:listArray];
        } else {
            NSMutableArray *listArray = [NSMutableArray array];
            
            for (NSDictionary *dic in showdata[@"familyList"]) {
                if ([dic[@"familyId"] isEqualToString:@"3941de33c5ef4900b201b14a7a39758f"]) {
                    continue;
                }
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"old"] = dic[@"familyElderList"];
                param[@"child"] = dic[@"familyOtherList"];
                param[@"familyId"] = dic[@"familyId"];
                [listArray addObject:param];
            }
            self.alltend = [listArray mutableCopy];
            
        }
        if (self.alltend.count == 0) {
            self.view.backgroundColor = LRRGBAColor(255, 255, 255, 1);
            [self setUpZero];
        } else {
            
            self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addBtnClick)];
            [self setUP];
        }
        
    }];
}
//没有群组时的布局
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
    centerLabel.text = @"点击添加看护群组";
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
//有群组时的布局
- (void)setUP {
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
    self.mainScroll.contentSize = CGSizeMake(0, 126 * self.alltend.count);
    [KRBaseTool tableViewAddRefreshFooter:self.mainScroll withTarget:self refreshingAction:@selector(loadMoreData)];
    [KRBaseTool tableViewAddRefreshHeader:self.mainScroll withTarget:self refreshingAction:@selector(loadData)];
    UIView *temp = self.mainScroll;
    for (int i = 0; i < self.alltend.count; i ++) {
        TendView *tend = [[TendView alloc]init];
        [self.mainScroll addSubview:tend];
        [tend mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(temp.mas_top).with.offset(10);
            } else {
                make.top.equalTo(temp.mas_bottom).with.offset(10);
            }
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.height.equalTo(@106);
        }];
        [tend setTendWithDic:self.alltend[i]];
        tend.block = ^(NSDictionary *dic) {
            AddTendViewController *addTend = [[AddTendViewController alloc]init];
            addTend.famliID = dic[@"familyId"];
            [self.navigationController pushViewController:addTend animated:YES];
        };
        temp = tend;
        
    }
}
- (void)viewDidAppear:(BOOL)animated {
    self.mainScroll.contentOffset = CGPointMake(0, 0);
}
//添加群组
- (void)addBtnClick {
    ChooseOlderViewController *vc = [[ChooseOlderViewController alloc]init];
    vc.type = 1;
    
    [self.navigationController pushViewController:vc animated:YES];
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
