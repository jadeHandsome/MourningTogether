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
    self.navigationItem.title = @"解除绑定";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    self.topConstraint.constant = navHight + 10;
    
}

- (IBAction)deleteDevice:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解绑该设备" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (IBAction)setDeviceName:(UITapGestureRecognizer *)sender {
    SetDeviceNameViewController *setNameVC = [SetDeviceNameViewController new];
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
