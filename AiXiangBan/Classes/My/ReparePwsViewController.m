//
//  ReparePwsViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ReparePwsViewController.h"

@interface ReparePwsViewController ()
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *repeatPwdTextField;
@end

@implementation ReparePwsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    [self setUP];
}
- (void)setUP {
    
    UIView *centerView = [[UIView alloc]init];
    
    centerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerView];
    LRViewBorderRadius(centerView, 5, 0, [UIColor clearColor]);
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight + 10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@90);
    }];
    UIView *temp = centerView;
    for (int i = 0 ; i < 2; i ++) {
        UIView *contentView = [[UIView alloc]init];
        [centerView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            
            make.left.equalTo(centerView.mas_left).with.offset(10);
            make.right.equalTo(centerView.mas_right).with.offset(-10);
            make.height.equalTo(@45);
        }];
        
        contentView.backgroundColor = [UIColor whiteColor];
        
        UITextField *infotext = [[UITextField alloc]init];
        if (i == 0) {
            self.pwdTextField = infotext;
        } else {
            self.repeatPwdTextField = infotext;
        }
        [contentView addSubview:infotext];
        [infotext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).with.offset(10);
            make.right.equalTo(contentView.mas_right);
            make.top.equalTo(contentView.mas_top);
            make.bottom.equalTo(contentView.mas_bottom);
        }];
        if (i == 0) {
            infotext.placeholder = @"原密码";
            UIView *lineView = [[UIView alloc]init];
            [centerView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(contentView.mas_bottom);
                make.right.equalTo(centerView.mas_right).with.offset(-10);
                make.left.equalTo(centerView.mas_left).with.offset(10);
                make.height.equalTo(@1);
            }];
            lineView.backgroundColor = LRRGBColor(200, 200, 200);
            temp = lineView;
        } else {
            infotext.placeholder = @"输入新密码6-16位的英文或数字";
        }
        
        infotext.secureTextEntry = YES;
        
        
    }
    UIButton *commit = [[UIButton alloc]init];
    [self.view addSubview:commit];
    [commit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
    }];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.backgroundColor = LRRGBColor(31, 174, 198);
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    LRViewBorderRadius(commit, 5, 0, [UIColor clearColor]);
    [commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];

    
}
- (void)commitClick {
    //提交修改
    if ([self cheakPwd:self.repeatPwdTextField.text]) {
        if ([self.pwdTextField.text isEqualToString:self.repeatPwdTextField.text]) {
            [self showHUDWithText:@"相同密码不需要修改"];
        } else {
            //修改密码
            NSString *oldPwd = [KRBaseTool md5:self.pwdTextField.text];
            NSString *newPwd = [KRBaseTool md5:self.repeatPwdTextField.text];
            [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/member/memberInfo/changePassword.do" params:@{@"password":oldPwd,@"newPassword":newPwd} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
                if (showdata == nil) {
                    return ;
                }
                [self showHUDWithText:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
    } else {
        [self showHUDWithText:@"密码格式输入不正确"];
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
