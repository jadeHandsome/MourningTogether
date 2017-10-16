//
//  TrackViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/14.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TrackViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "TRAnnotation.h"
@interface TrackViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UILabel *datelabel;
@end

@implementation TrackViewController
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"足迹";
    [self setUp];
    [self setUpMap];
    [self loadData];
}
- (void)loadData {
    self.param[@"offset"] = @0;
    self.param[@"size"] = @20;
    self.param[@"deviceId"] = [KRUserInfo sharedKRUserInfo].deviceId;
    [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:@"/device/getFootmarkList.do" params:self.param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        NSLog(@"%@",showdata);
        NSArray *list = showdata[@"footmarkList"];
        [self.mapView removeAnnotations:self.mapView.annotations];
        for (NSDictionary *dic in list) {
            TRAnnotation *pointAnnotation  = [[TRAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
            pointAnnotation.image = [UIImage imageNamed:@"云医时代-75"];
            [self.mapView addAnnotation:pointAnnotation];
        }
        if (list.count > 0) {
            NSDictionary *dic = list.firstObject;
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]) animated:YES];
        }
        
    }];
}
- (void)setUpMap {
    _mapView = [[MAMapView alloc] init];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.mapView setZoomLevel:12 animated:YES];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
}
- (void)setUp {
    UIView *dateView = [[UIView alloc]init];
    [self.view addSubview:dateView];
    [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
    }];
    UILabel *dateLabel = [[UILabel alloc]init];
    _datelabel = dateLabel;
    [dateView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateView.mas_left).with.offset(10);
        make.centerY.equalTo(dateView.mas_centerY);
        
    }];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"yyyy/MM/dd EEEE";
    
    NSString *dateStr = [dateFormater stringFromDate:date];

    dateLabel.text = dateStr;

    dateLabel.textColor = LRRGBColor(29, 185, 207);
    dateLabel.font = [UIFont systemFontOfSize:15];
    UIView *titleView = [[UIView alloc]init];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    UIView *temp = titleView;
    _titleView = titleView;
    for (int i = 0; i < 7; i ++) {
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_left);
            } else {
                make.left.equalTo(temp.mas_right);
            }
            make.top.equalTo(titleView.mas_top);
            make.bottom.equalTo(titleView.mas_bottom);
            make.width.equalTo(@((SCREEN_WIDTH - 2)/7));
        }];
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(147, 147, 147) forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(85, 183, 204) forState:UIControlStateSelected];
        titleBtn.tag = i + 100;
        temp = titleBtn;
        if (i == 0) {
            [titleBtn setSelected:YES];
        }
        
    }
    UIView *bottomLine = [[UIView alloc]init];
    [titleView addSubview:bottomLine];
    _bottomLine = bottomLine;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.bottom.equalTo(titleView.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@((SCREEN_WIDTH - 2)/7));
    }];
    bottomLine.backgroundColor = LRRGBColor(85, 183, 204);
    
}
- (void)titleClick:(UIButton *)sender {
    for (UIView *sub in self.titleView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            [btn setSelected:NO];
        }
    }
    NSDate * date = [NSDate date];//当前时间
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 * (sender.tag - 100) sinceDate:date];//前一天
    //NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"yyyy/MM/dd EEEE";
    NSString *dateStr = [dateFormater stringFromDate:lastDay];
    
    self.datelabel.text = dateStr;
    
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView.mas_left).with.offset((SCREEN_WIDTH - 2)/7 * (sender.tag - 100));
        }];
        
    } completion:^(BOOL finished) {
        [sender setSelected:YES];
        self.param[@"beginTime"] = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:lastDay];
        self.param[@"endTime"] = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:lastDay];
        [weakSelf loadData];
    }];
    
}
- (void)titleClick {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -- locationDelegae
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[TRAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        //typeof(self) weakSelf = self;
        //        annotationView.block = ^(NSDictionary *data) {
        //            [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake([data[@"lan"] doubleValue], [data[@"longtitud"] doubleValue]) animated:YES];
        //        };
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        TRAnnotation *anno = (TRAnnotation *)annotation;
        annotationView.image = anno.image;
        
        
        return annotationView;
    }
    return nil;
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
