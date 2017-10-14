//
//  AccountViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AccountViewController.h"
#import "RechargeViewController.h"
#import "RechargeRecordController.h"
#import "BillViewController.h"
#import "CallCardViewController.h"
@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"孝心币";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData{
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/trade/base/getAccountTradeInfo.do" params:nil withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (!showdata) {
            return ;
        }
        
        self.numbelLabel.text = [NSString stringWithFormat:@"账户余额(元) | %.2f",[showdata[@"balance"] floatValue]];
        SharedUserInfo.balance = [NSString stringWithFormat:@"%.2f",[showdata[@"balance"] floatValue]];
        
    }];
}

- (void)setUp{
    LRViewBorderRadius(self.topContainer, 10, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.bottomContainer, 10, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.headImage, 25, 5, ColorRgbAValue(0xffffff, 0.5));
    self.topConstraint.constant = navHight;
    self.accountLabel.text = SharedUserInfo.mobile;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:SharedUserInfo.headImgUrl] placeholderImage:IMAGE_NAMED(@"云医3-13")];
}


- (IBAction)recharge:(UITapGestureRecognizer *)sender {
    RechargeViewController *rechargeVC = [RechargeViewController new];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}
- (IBAction)record:(UITapGestureRecognizer *)sender {
    RechargeRecordController *record = [RechargeRecordController new];
    [self.navigationController pushViewController:record animated:YES];
}
- (IBAction)bill:(UITapGestureRecognizer *)sender {
    BillViewController *bill = [BillViewController new];
    [self.navigationController pushViewController:bill animated:YES];
}
- (IBAction)service:(UITapGestureRecognizer *)sender {
    CallCardViewController *callCardVC = [CallCardViewController new];
    [self.navigationController pushViewController:callCardVC animated:YES];
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
