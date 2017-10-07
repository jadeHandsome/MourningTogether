//
//  AboutUsViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (nonatomic, strong) UIScrollView *mineScrollView;
@property (nonatomic, strong) NSString *contentText;//服务协议或者关于我们
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.contentText = @"fasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasdfasdasd";
    [self setUp];
}

- (void)setUp {
    CGSize size = [KRBaseTool getNSStringSize:self.contentText andViewWight:SCREEN_WIDTH - 40 andFont:15];
    self.mineScrollView = [[UIScrollView alloc]init];
    self.mineScrollView.contentSize = CGSizeMake(0, size.height + 40);
    [self.view addSubview:self.mineScrollView];
    [self.mineScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    UIView *centerView = [[UIView alloc]init];
    [self.mineScrollView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height + 20));
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.mineScrollView.mas_top).with.offset(10);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(centerView, 10, 0, [UIColor clearColor]);
    UILabel *contentLabel = [[UILabel alloc]init];
    [self.mineScrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.mineScrollView.mas_top).with.offset(10);
        
    }];
    contentLabel.text = self.contentText;
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:15];
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
