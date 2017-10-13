//
//  BillDetailViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/12.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BillDetailViewController.h"

@interface BillDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPrice;
@property (weak, nonatomic) IBOutlet UILabel *voice;
@property (weak, nonatomic) IBOutlet UILabel *flow;

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"缴费详情";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    self.priceLabel.text = [NSString stringWithFormat:@"%g元",self.price];
    self.realPrice.text = [NSString stringWithFormat:@"%g元",self.price];
    NSArray *strArr = [self.consumeContent componentsSeparatedByString:@"&"];
    for (NSString *str in strArr) {
        if ([str rangeOfString:@"packageName"].location != NSNotFound) {
            NSArray *arr = [str componentsSeparatedByString:@"="];
            self.titleLabel.text = arr[1];
        }
        if ([str rangeOfString:@"voice"].location != NSNotFound) {
            NSArray *arr = [str componentsSeparatedByString:@"="];
            self.voice.text = [NSString stringWithFormat:@"%@分钟",arr[1]];
        }
        if ([str rangeOfString:@"flow"].location != NSNotFound) {
            NSArray *arr = [str componentsSeparatedByString:@"="];
            self.flow.text = [NSString stringWithFormat:@"%@MB钟",arr[1]];
        }
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
