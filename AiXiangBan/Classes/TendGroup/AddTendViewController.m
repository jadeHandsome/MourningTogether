//
//  AddTendViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddTendViewController.h"
#import "AddTendView.h"
@interface AddTendViewController ()

@property (nonatomic, strong) UIScrollView *mainScroll;
@end

@implementation AddTendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加看护群组";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.alltend = @[@{@"title":@"老人",@"child":@[@{@"equipment":@[@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""}],@"name":@"爸爸"},@{@"equipment":@[@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""},@{@"eqName":@"看看",@"eqImage":@""}],@"name":@"爸爸"}]},@{@"title":@"监护人",@"child":@[@{@"name":@"大儿子"},@{@"name":@"二儿子"}]},@{@"title":@"亲属邻里",@"child":@[@{@"name":@"大儿子"},@{@"name":@"二儿子"}]}];
    [self setUp];
    // Do any additional setup after loading the view.
}
- (void)setUp {
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
                h += size.height + 20 + 55 + ([self.alltend[0][@"child"][j][@"equipment"] count]/3 + 1) * 15 + [self.alltend[0][@"child"][j][@"equipment"] count]/3 * 20 + 20;
            }
            height = 90 + h;
            self.mainScroll.contentSize = CGSizeMake(0, 40 + 2 * 115 + h + 90);
        } else {
            height = 115;
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
        
        temp = tend;
        
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
