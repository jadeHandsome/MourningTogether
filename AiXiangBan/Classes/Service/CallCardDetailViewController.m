//
//  CallCardDetailViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/13.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CallCardDetailViewController.h"

@interface CallCardDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;

@end

@implementation CallCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    self.topConstraint.constant = navHight + 10;
    self.titleLabel.text = self.package[@"packageName"];
    self.costLabel.text = [NSString stringWithFormat:@"%g元",[self.package[@"cost"] floatValue]];
    self.voiceLabel.text = [NSString stringWithFormat:@"%g分钟",[self.package[@"voice"] floatValue]];
    self.flowLabel.text = [NSString stringWithFormat:@"%gMB",[self.package[@"flow"] floatValue]];
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
