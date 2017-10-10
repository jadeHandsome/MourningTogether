//
//  AddbyViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddbyViewController.h"

@interface AddbyViewController ()
@property (nonatomic, strong) UITextField *texifield;
@end

@implementation AddbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入序列号";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)setUp{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(view, 10, 0, [UIColor clearColor]);
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.top.equalTo(self.view).with.offset(navHight + 10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@45);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:16];
    textField.placeholder = @"请输入序列号";
    [view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(10);
        make.top.equalTo(view).with.offset(0);
        make.right.equalTo(view).with.offset(-10);
        make.bottom.equalTo(view).with.offset(0);
    }];
    self.texifield = textField;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = ThemeColor;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(button, 10, 0, ThemeColor);
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@45);
    }];
    
}

- (void)submit:(UIButton *)sender{
    
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
