//
//  SetDeviceNameViewController.m
//  孝相伴
//
//  Created by MAC on 17/10/10.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "SetDeviceNameViewController.h"

@interface SetDeviceNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation SetDeviceNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    self.topConstraint.constant = navHight + 10;
    self.navigationItem.title = @"修改设备名";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.textField.text = self.deviceName;
    // Do any additional setup after loading the view from its nib.
}

- (void)save{
    if (self.textField.text) {
        NSDictionary *params = @{@"deviceId":self.deviceId,@"deviceName":self.textField.text,@"devicePower":@1};
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/device/setDeviceName.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata) {
                [[NSNotificationCenter defaultCenter] postNotificationName:FIX_DEVICE_NAME object:self.textField.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else{
        [self showHUDWithText:@"设备名不能为空"];
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
