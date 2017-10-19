//
//  HeartRateViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HeartRateViewController.h"

@interface HeartRateViewController ()
@property (nonatomic, assign) NSInteger nowCount;
@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"心率";
    self.nowCount = 0;
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData{
    NSString *beginTime = [KRBaseTool timeStringFromFormat:@"yyyyMMdd000000" withDate:[NSDate date]];
    NSString *endTime = [KRBaseTool timeStringFromFormat:@"yyyyMMddHHmmss" withDate:[NSDate date]];
    NSDictionary *params = @{@"deviceId":[KRUserInfo sharedKRUserInfo].deviceSn,@"beginTime":beginTime,@"endTime":endTime,@"offset":@(self.nowCount),@"size":@(30)};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/device/getHeartList.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            for (NSDictionary *dic in showdata[@"heartList"]) {
                NSString * timeStampString = dic[@"heartTime"];
                NSTimeInterval _interval = [timeStampString doubleValue] / 1000.0;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
                [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSLog(@"%@", [objDateformat stringFromDate: date]);
            }
        }
    }];
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
