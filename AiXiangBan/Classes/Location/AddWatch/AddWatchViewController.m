//
//  AddWatchViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/12.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddWatchViewController.h"
#import "AddByQRCodeViewController.h"
#import "WatchXixunViewController.h"
@interface AddWatchViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSArray *sortArray;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIScrollView *bottomScro;
@property (nonatomic, strong) UITextField *inpuText;
@end

@implementation AddWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加手表";
    self.sortArray = @[@"二维码",@"输入IMEI号"];
    [self setUP];
    [self setScro];
}
- (void)setScro {
    
    self.bottomScro = [[UIScrollView alloc]init];
    
    
    [self.view addSubview:self.bottomScro];
    self.bottomScro.delegate = self;
    [self.bottomScro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.titleView.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.bottomScro.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.bottomScro.showsVerticalScrollIndicator = NO;
    self.bottomScro.showsHorizontalScrollIndicator = NO;
    self.bottomScro.pagingEnabled = YES;
    UIView *erWeiView = [[UIView alloc]init];
    [self.bottomScro addSubview:erWeiView];
    [erWeiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomScro.mas_left);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [self setUpErWeiWith:erWeiView];
    
    UIView *IMEI = [[UIView alloc]init];
    [self.bottomScro addSubview:IMEI];
    [IMEI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(erWeiView.mas_right);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [self setUpImeiWith:IMEI];
    
    
}
//初始化二维码的View
- (void)setUpErWeiWith:(UIView *)myView {
    UIButton *clickBtn = [[UIButton alloc]init];
    [myView addSubview:clickBtn];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myView.mas_left).with.offset(10);
        make.right.equalTo(myView.mas_right).with.offset(-10);
        make.bottom.equalTo(myView.mas_bottom).with.offset(-10);
        make.height.equalTo(@45);
    }];
    LRViewBorderRadius(clickBtn, 5, 0, [UIColor clearColor]);
    clickBtn.backgroundColor = LRRGBColor(29, 185, 207);
    [clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clickBtn setTitle:@"点击扫描二维码" forState:UIControlStateNormal];
    myView.backgroundColor = LRRGBColor(242, 242, 242);
    [clickBtn addTarget:self action:@selector(gotoScan) forControlEvents:UIControlEventTouchUpInside];
    UIView *subView = [[UIView alloc]init];
    [myView addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myView.mas_left).with.offset(10);
        make.right.equalTo(myView.mas_right).with.offset(-10);
        make.top.equalTo(myView.mas_top).with.offset(10);
        make.bottom.equalTo(clickBtn.mas_top).with.offset(-40);
    }];
    LRViewBorderRadius(subView, 5, 0, [UIColor clearColor]);
    subView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    [subView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subView.mas_left);
        make.right.equalTo(subView.mas_right);
        make.top.equalTo(subView.mas_top);
        make.height.equalTo(@35);
    }];
    titleLabel.textColor = LRRGBColor(154, 154, 154);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"请保持手表开机状态,扫描二维码";
    
    UIButton *detail = [[UIButton alloc]init];
    [subView addSubview:detail];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subView.mas_left);
        make.right.equalTo(subView.mas_right);
        make.bottom.equalTo(subView.mas_bottom);
        make.height.equalTo(@35);
    }];
    [detail setTitleColor:LRRGBColor(255, 18, 16) forState:UIControlStateNormal];
    [detail setTitle:@"无手表点击咨询" forState:UIControlStateNormal];
    [detail addTarget:self action:@selector(gotoZixun) forControlEvents:UIControlEventTouchUpInside];
    UIView *centerView = [[UIView alloc]init];
    [subView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subView.mas_left).with.offset(10);
        make.right.equalTo(subView.mas_right).with.offset(-10);
        make.top.equalTo(titleLabel.mas_bottom);
        make.bottom.equalTo(detail.mas_top);
    }];
    centerView.backgroundColor = LRRGBColor(230, 230, 230);
}
- (void)gotoScan {
    //扫描二维码
    AddByQRCodeViewController *QRCodeVC = [AddByQRCodeViewController new];
    QRCodeVC.deviceType = 1;
    [self.navigationController pushViewController:QRCodeVC animated:YES];
    
}
- (void)gotoZixun {
    //去咨询
    WatchXixunViewController *watch = [[WatchXixunViewController alloc]init];
    [self.navigationController pushViewController:watch animated:YES];
}
//初始化输入imei的View
- (void)setUpImeiWith:(UIView *)myView {
    myView.backgroundColor = LRRGBColor(242, 242, 242);
    UIView *contentView = [[UIView alloc]init];
    [myView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myView.mas_top).with.offset(10);
        make.left.equalTo(myView.mas_left).with.offset(10);
        make.right.equalTo(myView.mas_right).with.offset(-10);
        make.height.equalTo(@50);
    }];
    LRViewBorderRadius(contentView, 5, 0, [UIColor clearColor]);
    contentView.backgroundColor = [UIColor whiteColor];
    
    UITextField *infotext = [[UITextField alloc]init];
    _inpuText = infotext;
    [contentView addSubview:infotext];
    [infotext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right);
        make.top.equalTo(contentView.mas_top);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    infotext.placeholder = @"请输入IMEI号";
    UIButton *sureBtn = [[UIButton alloc]init];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.bottom.equalTo(myView.mas_bottom).with.offset(-10);
        make.height.equalTo(@45);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    sureBtn.backgroundColor = LRRGBColor(100, 192, 210);
    [sureBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(sureBtn, 5, 0, [UIColor clearColor]);
    [sureBtn addTarget:self action:@selector(netStep) forControlEvents:UIControlEventTouchUpInside];
}
- (void)netStep {
    //输入imei后下一步
}
- (void)setUP {
    UIView *titleView = [[UIView alloc]init];
    _titleView = titleView;
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    UIView *temp = titleView;
    for (int i = 0; i < 2; i ++) {
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_left);
            } else {
                make.left.equalTo(temp.mas_right);
            }
            make.top.equalTo(titleView.mas_top);
            make.bottom.equalTo(titleView.mas_bottom);
            make.width.equalTo(@((SCREEN_WIDTH - 2)*0.5));
        }];
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:self.sortArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(147, 147, 147) forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(85, 183, 204) forState:UIControlStateSelected];
        titleBtn.tag = i + 100;
        if (i < 1) {
            UIView *line = [[UIView alloc]init];
            [titleView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleBtn.mas_right);
                make.width.equalTo(@1);
                make.height.equalTo(@22);
                make.centerY.equalTo(titleView.mas_centerY);
            }];
            line.backgroundColor =LRRGBColor(147, 147, 147);
            temp = line;
        }
        if (i == 0) {
            [titleBtn setSelected:YES];
        }
        
    }
    UIView *bottomLine = [[UIView alloc]init];
    [titleView addSubview:bottomLine];
    _bottomLine = bottomLine;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.bottom.equalTo(titleView.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@((SCREEN_WIDTH - 2)*0.5));
    }];
    bottomLine.backgroundColor = LRRGBColor(85, 183, 204);
}
- (void)titleClick:(UIButton *)sender {
    for (UIView *sub in self.titleView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            [btn setSelected:NO];
        }
    }
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView.mas_left).with.offset((SCREEN_WIDTH - 2)*0.5 * (sender.tag - 100));
        }];
        self.bottomScro.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 100), 0);
    } completion:^(BOOL finished) {
        [sender setSelected:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x / SCREEN_WIDTH == 0.0) {
        UIButton *btn = [self.titleView viewWithTag:100];
        [self titleClick:btn];
    } else if (scrollView.contentOffset.x / SCREEN_WIDTH == 1.0) {
        UIButton *btn = [self.titleView viewWithTag:101];
        [self titleClick:btn];
    }
}


@end
