//
//  NewAddwatchViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/20.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddWatchsViewController.h"

@interface AddWatchsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *devieceSnTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceOnlyTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *scondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCont;

@end

@implementation AddWatchsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加手表";
    self.topCont.constant = navHight + 10;
    
    
    LRViewBorderRadius(self.topView, 5, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.scondView, 5, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.thirdView, 5, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.sureBtn, 5, 0, [UIColor clearColor]);
}
- (void)viewWillAppear:(BOOL)animated {
    self.topView.backgroundColor = [UIColor whiteColor];
    self.scondView.backgroundColor = [UIColor whiteColor];
    self.thirdView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureBtnClick:(id)sender {
    if ([self check]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"deviceSerialNo"] = self.devieceSnTextField.text;
        param[@"deviceName"] = @"手表";
        param[@"deviceType"] = @"1";
        param[@"mobile"] = self.phoneNumTextFeild.text;
        param[@"validateCode"] = @"";
        param[@"devicePassword"] = @"";
        param[@"elderId"] = [KRUserInfo sharedKRUserInfo].elderId;
        __weak typeof(self) weakSelf = self;
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/device/addDevice.do" params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [weakSelf bindSim];
        }];
    }
    
}
- (void)bindSim {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"elderId"] = [KRUserInfo sharedKRUserInfo].currentElder[@"elderId"];
    param[@"elderName"] = [KRUserInfo sharedKRUserInfo].currentElder[@"elderName"];
    param[@"idCard"] = [KRUserInfo sharedKRUserInfo].currentElder[@"idCard"];
    param[@"simIccid"] = self.deviceOnlyTextField.text;
    param[@"simMsisdn"] = self.phoneNumTextFeild.text;
    param[@"memberId"] = [KRUserInfo sharedKRUserInfo].memberId;
    param[@"mobile"] = [KRUserInfo sharedKRUserInfo].mobile;
    param[@"name"] = [KRUserInfo sharedKRUserInfo].memberName;
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/trade/base/addCommunityMember.do" params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:@"添加成功" toView:self.view.window];
    }];
}
- (BOOL)check {
    if (self.devieceSnTextField.text.length != 10) {
        [MBProgressHUD showError:@"请输入正确序列号" toView:self.view];
        return NO;
    }
    if (self.deviceOnlyTextField.text.length != 20) {
        [MBProgressHUD showError:@"请输入正确唯一标识" toView:self.view];
        return NO;
    }
    if (self.phoneNumTextFeild.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确手机号" toView:self.view];
        return NO;
    }
    return YES;
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

