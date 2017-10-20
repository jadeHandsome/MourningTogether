//
//  HeartRateViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HeartRateViewController.h"
#import "lineView.h"
@interface HeartRateViewController ()
@property (nonatomic, assign) NSInteger nowCount;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *xArr;
@property (nonatomic, strong) NSMutableArray *yArr;
@property (nonatomic, strong) NSMutableArray *pointArr;
@property (nonatomic, assign) NSInteger yMax;
@property (nonatomic, assign) NSInteger yMin;
@end

@implementation HeartRateViewController
- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableArray *)xArr{
    if (!_xArr) {
        _xArr = [NSMutableArray array];
    }
    return _xArr;
}

- (NSMutableArray *)yArr{
    if (!_yArr) {
        _yArr = [NSMutableArray array];
    }
    return _yArr;
}

- (NSMutableArray *)pointArr{
    if (!_pointArr) {
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}




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
        if ([showdata[@"heartList"] count]) {
            self.yMax = [showdata[@"maxHeart"] integerValue];
            self.yMin = [showdata[@"minHeart"] integerValue];
            [self.data addObjectsFromArray:showdata[@"heartList"]];
            self.nowCount += 30;
            [self requestData];
        }
        else{
            [self math];
        }
    }];
}

- (void)math{
    self.data = [[self.data reverseObjectEnumerator] allObjects].mutableCopy;
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"HH:mm:ss"];
    NSString * minStr = [self.data firstObject][@"heartTime"];
    NSTimeInterval minInterval = [minStr doubleValue] / 1000.0;
    NSDate *minData = [NSDate dateWithTimeIntervalSince1970:minInterval];
    NSString *xMin = [[objDateformat stringFromDate:minData] substringToIndex:2];
    NSString * maxStr = [self.data lastObject][@"heartTime"];
    NSTimeInterval maxInterval = [maxStr doubleValue] / 1000.0;
    NSDate *maxData = [NSDate dateWithTimeIntervalSince1970:maxInterval];
    NSString *xMax = [[objDateformat stringFromDate:maxData] substringToIndex:2];
    for (int i = 0; i < [xMax integerValue] - [xMin integerValue]; i++) {
        [self.xArr addObject:[NSString stringWithFormat:@"%ld",[xMin integerValue]+i]];
    }
    
    self.yArr = @[@"0",@"20",@"40",@"60",@"80",@"100",@"120",@"140",@"160",@"180",@"200"].mutableCopy;
    
    for (NSDictionary *dic in self.data) {
            }
    
    [self setUpUI];
    
    
}

- (void)setUpUI{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navHight, SIZEWIDTH, 500)];
    scrollView.contentSize = CGSizeMake(SIZEWIDTH * 2, 500);
    [self.view addSubview:scrollView];
    lineView *view = [[lineView alloc] initWithFrame:CGRectMake(0, 0, SIZEWIDTH * 2, 500)];
    view.xArr = self.xArr;
    view.yArr = self.yArr;
    view.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view];
//    [view setNeedsDisplay];
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
