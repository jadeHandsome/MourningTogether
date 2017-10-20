//
//  RestSosViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/20.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RestSosViewController.h"

@interface RestSosViewController ()
@property (weak, nonatomic) IBOutlet UIView *numOneView;
@property (weak, nonatomic) IBOutlet UIView *numTwoView;
@property (weak, nonatomic) IBOutlet UIView *numThreeView;
@property (weak, nonatomic) IBOutlet UITextField *numOneText;
@property (weak, nonatomic) IBOutlet UITextField *numTwoText;
@property (weak, nonatomic) IBOutlet UITextField *numThreeText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCant;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation RestSosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置SOS号码";
    LRViewBorderRadius(self.numOneView, 5, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.numTwoView, 5, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.numThreeView, 5, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.sureBtn, 5, 0, [UIColor clearColor]);
    self.topCant.constant = navHight + 10;
    [self getData];
}
- (void)getData {
    [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:@"device/getSosList.do" params:@{@"deviceId":self.deviceId} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        self.numOneText.text = showdata[@"sos1"];
        self.numTwoText.text = showdata[@"sos2"];
        self.numThreeText.text = showdata[@"sos3"];
    }];
}
- (IBAction)sureClick:(id)sender {
    if ([self check]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"deviceId"] = self.deviceId;
        if (self.numOneText.text.length > 0) {
            param[@"sos1"] = self.numOneText.text;
        } else {
            param[@"sos1"] = @"";
        }
        if (self.numTwoText.text.length > 0) {
            param[@"sos2"] = self.numTwoText.text;
        } else {
            param[@"sos2"] = @"";
        }
        if (self.numThreeText.text.length > 0) {
            param[@"sos3"] = self.numThreeText.text;
        } else {
            param[@"sos3"] = @"";
        }
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"device/setSosList.do" params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view.window];
        }];
    }
    
}
- (BOOL)check {
    if (self.numOneText.text.length > 0 && self.numOneText.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确格式号码" toView:self.view];
        return NO;
    }
    if (self.numTwoText.text.length > 0 && self.numTwoText.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确格式号码" toView:self.view];
        return NO;
    }
    if (self.numThreeText.text.length > 0 && self.numThreeText.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确格式号码" toView:self.view];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
