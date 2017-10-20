//
//  HeartRateViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "heartRateController.h"
#import "lineView.h"
@interface heartRateController ()
@property (nonatomic, assign) NSInteger nowCount;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *xArr;
@property (nonatomic, strong) NSMutableArray *yArr;
@property (nonatomic, strong) NSMutableArray *pointArr;
@property (nonatomic, assign) NSInteger yMax;
@property (nonatomic, assign) NSInteger yMin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *averNum;
@property (weak, nonatomic) IBOutlet UILabel *minNum;
@property (weak, nonatomic) IBOutlet UILabel *maxNum;
@property (weak, nonatomic) IBOutlet UILabel *minTime;
@property (weak, nonatomic) IBOutlet UILabel *maxTime;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation heartRateController
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
    self.topConstraint.constant = navHight;
    self.scrollView.contentSize = CGSizeMake(SIZEWIDTH * 2, SIZEHEIGHT * 0.5);
    self.bottomView.hidden = YES;
    self.scrollView.hidden = YES;
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
            if (self.bottomView.hidden) {
                self.bottomView.hidden = NO;
                self.averNum.text = [NSString stringWithFormat:@"%ld",[showdata[@"aveHeart"] integerValue]];
                self.minNum.text = [NSString stringWithFormat:@"%ld",[showdata[@"minHeart"] integerValue]];
                self.maxNum.text = [NSString stringWithFormat:@"%ld",[showdata[@"maxHeart"] integerValue]];
                self.minTime.text = [showdata[@"minHeartDate"] substringWithRange:NSMakeRange(10, 6)];
                self.maxTime.text = [showdata[@"maxHeartDate"] substringWithRange:NSMakeRange(10, 6)];
                self.timeLabel.text = [showdata[@"maxHeartDate"] substringToIndex:10];
            }
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
        NSString * Str = dic[@"heartTime"];
        NSTimeInterval Interval = [Str doubleValue] / 1000.0;
        NSDate *Data = [NSDate dateWithTimeIntervalSince1970:Interval];
        NSString *time = [objDateformat stringFromDate:Data];
        NSInteger hour = [[time substringToIndex:2] integerValue];
        NSInteger mm = [[time substringWithRange:NSMakeRange(3, 2)] integerValue];
        CGFloat x = hour - [xMin integerValue] + mm / 60.0;
        CGFloat y = [dic[@"heart"] integerValue] / 20.0;
        CGPoint point = CGPointMake(x, y);
        [self.pointArr addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [self addLineView];
    
    
}

- (void)addLineView{
    self.scrollView.hidden = NO;
    lineView *line = [[lineView alloc] initWithFrame:CGRectMake(0, 0, SIZEWIDTH * 2, SIZEHEIGHT * 0.5)];
    line.xArr = self.xArr;
    line.yArr = self.yArr;
    line.dataArr = self.pointArr;
    line.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:line];
    
    
    
    
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

