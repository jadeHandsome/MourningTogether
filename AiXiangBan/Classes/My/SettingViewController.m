//
//  SettingViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "SettingViewController.h"
#import "MineInfoView.h"
#import "AboutUsViewController.h"
#import "ReparePwsViewController.h"
#import "QYSDK.h"
#import "LoginViewController.h"
#import "BaseNaviViewController.h"
@interface SettingViewController ()
@property (nonatomic, strong) NSArray *allData;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    NSString *version = [@"" stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.allData = @[@{@"isImage":@"0",@"title":@"关于我们",@"right":@"",@"leftFont":@"17"},@{@"isImage":@"0",@"title":@"服务协议",@"right":@"",@"leftFont":@"17"},@{@"isImage":@"0",@"title":@"当前版本",@"right":version,@"leftFont":@"17",@"noRight":@"1"},@{@"isImage":@"0",@"title":@"修改密码",@"right":@"",@"leftFont":@"17"}];
    [self setUp];
}
- (void)setUp {
    UIView *centerView = [[UIView alloc]init];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@180);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.view.mas_top).with.offset(10 + navHight);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(centerView, 10, 0, [UIColor clearColor]);
    UIView *temp = centerView;
    for (int i = 0; i < 4; i ++) {
        MineInfoView *infoView = [[MineInfoView alloc]init];
        [infoView setUpWithDic:self.allData[i] withClickHandle:^{
            LRLog(@"点了第%d个",i);
            AboutUsViewController *about = [[AboutUsViewController alloc]init];
            if (i == 0) {
                about.title = @"关于我们";
                [self.navigationController pushViewController:about animated:YES];
                
            } else if (i == 1) {
                about.title = @"服务协议";
                [self.navigationController pushViewController:about animated:YES];
            } else if (i == 3) {
                //修改密码
                ReparePwsViewController *repare = [[ReparePwsViewController alloc]init];
                [self.navigationController pushViewController:repare animated:YES];
            }
            
            
        }];
        [centerView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView.mas_right);
            make.left.equalTo(centerView.mas_left);
             make.height.equalTo(@45);
            if (i == 0) {
                
                make.top.equalTo(temp.mas_top);
            } else {
               
                make.top.equalTo(temp.mas_bottom);
            }
        }];
        temp = infoView;
    }
    UIButton *logOut = [[UIButton alloc]init];
    [self.view addSubview:logOut];
    [logOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
    }];
    [logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOut.backgroundColor = LRRGBColor(31, 174, 198);
    [logOut setTitle:@"退出" forState:UIControlStateNormal];
    LRViewBorderRadius(logOut, 5, 0, [UIColor clearColor]);
    [logOut addTarget:self action:@selector(logOUtClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)logOUtClick {
    //退出登录
    //退出登录要掉客服的注销
//    [[QYSDK sharedSDK] logout:^(){}];
    //删除
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/member/login/doLogout.do" params:nil withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [KRUserInfo sharedKRUserInfo].token = nil;
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
            LoginViewController *loginVC = [LoginViewController new];
            self.view.window.rootViewController = [[BaseNaviViewController alloc]initWithRootViewController:loginVC];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
