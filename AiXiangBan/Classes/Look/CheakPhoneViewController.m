//
//  CheakPhoneViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CheakPhoneViewController.h"

@interface CheakPhoneViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@end

@implementation CheakPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频激活";
    self.view.backgroundColor = COLOR(242, 242, 241, 1);
    self.time = 60;
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    self.topConstraint.constant = navHight + 10;
    self.phoneLabel.text = [KRUserInfo sharedKRUserInfo].mobile;
    LRViewBorderRadius(self.topView, 10, 0, [UIColor whiteColor]);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
}
- (IBAction)getCode:(UIButton *)sender {
    [self startTime];
}

- (void)startTime{
    self.timeButton.enabled = NO;
    [self.timeButton setTitle:@"60S" forState:UIControlStateNormal];
    self.timer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setBtn:) userInfo:nil repeats:YES];
}

- (void)setBtn:(NSTimer *)sender{
    if (self.time > 0) {
        [self.timeButton setTitle:[NSString stringWithFormat:@"%ldS",--self.time] forState:UIControlStateNormal];
    }
    else{
        self.timeButton.enabled = YES;
        [self.timer invalidate];
        [self.timeButton setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}

- (void)next{
    if (self.textField.text) {
        
    }
    else{
        [self showHUDWithText:@"验证码不能为空"];
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
