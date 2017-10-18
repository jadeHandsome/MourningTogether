//
//  HealthyTypeViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/11.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HealthyTypeViewController.h"
#import "HealthyTypeView.h"
@interface HealthyTypeViewController ()
@property (nonatomic, strong) NSArray *allItems;//所有健康状况的数组
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *paramArray;
@end

@implementation HealthyTypeViewController
- (NSMutableArray *)paramArray {
    if (!_paramArray) {
        _paramArray = [NSMutableArray array];
    }
    return _paramArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.navigationItem.title = @"健康状况";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnClick)];
    [self getHealthyData];
    //[self setUP];
}
- (void)saveBtnClick {
    //保存
    if (self.block) {
        self.block([self.paramArray copy]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)getHealthyData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/health/getHealthList.do" params:@{@"offset":@"0",@"size":@"20"} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        NSMutableSet *set = [NSMutableSet set];
        for (NSDictionary *dic in showdata[@"healthList"]) {
            NSLog(@"\n\n");
            NSLog(@"%@",dic[@"healthType"]);
            NSLog(@"%@",dic[@"healthId"]);
            NSLog(@"%@",dic[@"healthDescribe"]);
            [set addObject:dic[@"healthType"]];
            
        }
        NSMutableArray *newArray = [NSMutableArray array];
        for (NSString *type in set) {
            NSMutableDictionary *mud = [NSMutableDictionary dictionary];
            mud[@"title"] = type;
            
            NSMutableArray *items = [NSMutableArray array];
            for (NSDictionary *dic in showdata[@"healthList"]) {
                if ([type isEqualToString:dic[@"healthType"]]) {
                    [items addObject:dic];
                }
                
                
            }
            mud[@"items"] = items;
            [newArray addObject:mud];
        }
        self.allItems = [newArray copy];
        [self setUP];
        NSLog(@"%@",showdata);
    }];
}
- (void)setUP {
    self.mainScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
    UIView *temp = _mainScrollView;
    CGFloat h = 0;
    for (int i = 0; i < self.allItems.count; i ++) {
        HealthyTypeView *type = [[HealthyTypeView alloc]init];
        [self.mainScrollView addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(temp.mas_top).with.offset(10);
            } else {
                make.top.equalTo(temp.mas_bottom).with.offset(10);
            }
            make.left.equalTo(self.mainScrollView.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.height.equalTo(@(40 + [UIScreen mainScreen].bounds.size.width * 0.3 * 0.38 * ([self.allItems[i][@"items"] count] + 2)/3 + 20 * (([self.allItems[i][@"items"] count] + 2)/3)));
        }];
        if (i == 0) {
            type.canChooseMore = YES;
        }
        h += 40 + [UIScreen mainScreen].bounds.size.width * 0.3 * 0.38 * ([self.allItems[i][@"items"] count] + 2)/3 + 20 * (([self.allItems[i][@"items"] count] + 2)/3);
        [type setHealthWith:self.allItems[i] andParam:self.paramArray];
        temp = type;
    }
    self.mainScrollView.contentSize = CGSizeMake(0, h + (self.allItems.count + 1) * 10);
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
