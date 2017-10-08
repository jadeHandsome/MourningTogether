//
//  AddAddressViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/8.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddAddressView.h"
@interface AddAddressViewController ()
@property (nonatomic, strong) UIScrollView *mainScrool;
@end

@implementation AddAddressViewController
{
    NSInteger typeCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    if (self.type == 1) {
        typeCount = 9;
        self.navigationItem.title = @"添加老人";
    } else if (self.type == 2) {
        typeCount = 3;
        self.navigationItem.title = @"添加监护人";
    } else {
        typeCount = 3;
        self.navigationItem.title = @"添加亲属邻里";
    }
    [self setUP];
}
- (void)finish {
    
}
- (void)setUP {
    self.mainScrool = [[UIScrollView alloc]init];
    [self.view addSubview:self.mainScrool];
    [self.mainScrool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.mainScrool.contentSize = CGSizeMake(0, 50 + 45 * typeCount);
    UIView *centerView = [[UIView alloc]init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.mainScrool addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrool.mas_top).with.offset(50);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@(45 * typeCount + 50));
    }];
    LRViewBorderRadius(centerView, 5, 0, [UIColor whiteColor]);
    
    UIView *temp = centerView;
    for (int i = 0; i < typeCount; i ++) {
        AddAddressView *add = [[AddAddressView alloc]init];
        [centerView addSubview:add];
        [add mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i ==0) {
                make.top.equalTo(temp.mas_top).with.offset(50);
                
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.height.equalTo(@45);
            make.left.equalTo(centerView.mas_left);
            make.right.equalTo(centerView.mas_right);
        }];
        [add setUpWithTag:i + 1 andParam:[NSMutableDictionary dictionary] andType:self.type];
        temp = add;
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.mainScrool addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrool.mas_top).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@75);
        make.height.equalTo(@75);
    }];
    imageView.image = [UIImage imageNamed:@"孝相伴-27"];
    LRViewBorderRadius(imageView, 37.5, 0, [UIColor clearColor]);
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
