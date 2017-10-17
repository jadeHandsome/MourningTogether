//
//  DeleteDeviceViewController.m
//  孝相伴
//
//  Created by MAC on 17/10/10.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "DeleteDeviceViewController.h"
#import "SetDeviceNameViewController.h"
@interface DeleteDeviceViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation DeleteDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"删除设备";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixName:) name:FIX_DEVICE_NAME object:nil];
    self.topConstraint.constant = navHight + 10;
    self.nameLabel.text = self.deviceName;
    LRViewBorderRadius(self.deleteBtn, 10, 0, [UIColor whiteColor]);
}

- (void)fixName:(NSNotification*)sender{
    self.nameLabel.text = (NSString *)sender.object;
}

- (IBAction)deleteDevice:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解绑该设备" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *params = @{@"deviceId":self.deviceId};
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/device/deleteDevice.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata) {
                [EZOPENSDK deleteDevice:self.deviceSerialNo completion:^(NSError *error) {
                    if (!error) {
                        self.block();
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        [self showHUDWithText:[NSString stringWithFormat:@"删除失败%ld",error.code]];
                    }
                }];
            }
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (IBAction)setDeviceName:(UITapGestureRecognizer *)sender {
    SetDeviceNameViewController *setNameVC = [SetDeviceNameViewController new];
    setNameVC.deviceId = self.deviceId;
    setNameVC.devicePower = self.devicePower;
    setNameVC.deviceName = self.deviceName;
    [self.navigationController pushViewController:setNameVC animated:YES];
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
