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
#import "TrackListViewController.h"
@interface TrackViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UILabel *datelabel;
@property (nonatomic, strong) NSMutableArray *allPoint;

@end

@implementation TrackViewController
{
    NSInteger count;
}
- (NSMutableArray *)allPoint {
    if (!_allPoint) {
        _allPoint = [NSMutableArray array];
        
    }
    return _allPoint;
}
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"轨迹";
    count = 0;
    [self setUp];
    [self setUpMap];
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]];//后一天
    self.param[@"beginTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd000000" withDate:[NSDate date]];
    self.param[@"endTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd235959" withDate:[NSDate date]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"云医时代-78"] style:UIBarButtonItemStyleDone target:self action:@selector(showTab)];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self loadData];
    //[self setUpTab];
}
- (void)showTab {
    NSInteger tag = 0;
    for (UIButton *btn in self.titleView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.selected) {
                tag = btn.tag;
            }
        }
    }
    TrackListViewController *list = [[TrackListViewController alloc]init];
    list.currentDay = tag;
    [self.navigationController pushViewController:list animated:YES];
}
- (void)loadData {
    
    count = self.allPoint.count;
    NSLog(@"%ld",count);
    self.param[@"offset"] = @(count);
    self.param[@"size"] = @(30);
    self.param[@"deviceId"] = [KRUserInfo sharedKRUserInfo].deviceSn;
    [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:@"/device/getFootmarkList.do" params:self.param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        
        NSArray *list = showdata[@"footmarkList"];
        
        //NSMutableArray *annos = [NSMutableArray array];
        for (NSDictionary *dic in list) {
            TRAnnotation *pointAnnotation  = [[TRAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([dic[@"footmarkLatitude"] doubleValue], [dic[@"footmarkLongitude"] doubleValue]);
            pointAnnotation.image = [UIImage imageNamed:@"云医时代-75"];
            pointAnnotation.anTag = [list indexOfObject:dic];
            //[annos addObject:pointAnnotation];
            [self.allPoint addObject:pointAnnotation];
            
        }
        //[ addObjectsFromArray:annos];
        if ([showdata[@"footmarkList"] count] == 0) {
            for (int i = 0; i < self.allPoint.count; i ++) {
                ((TRAnnotation *)self.allPoint[i]).anTag = i + 1;
            }
            [self.mapView addAnnotations:self.allPoint];
            if (self.allPoint.count > 0) {
                TRAnnotation *dic = self.allPoint.firstObject;
                [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(dic.coordinate.latitude , dic.coordinate.longitude) animated:YES];
            }
            NSLog(@"%ld",self.allPoint.count);
        } else {
            [self loadData];
        }
        
        
        
        
    }];
}
- (void)setUpMap {
    _mapView = [[MAMapView alloc] init];
    //_mapView.showsUserLocation = YES;
    //_mapView.userTrackingMode = MAUserTrackingModeFollow;
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
    NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60 * (sender.tag - 101) sinceDate:date];//后一天
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
        [self.allPoint removeAllObjects];
        count = 0;
        self.param[@"beginTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd000000" withDate:lastDay];
        self.param[@"endTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd235959" withDate:lastDay];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [weakSelf loadData];
    }];
    
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
        annotationView.image = [self addNumImages:anno.image andText:[NSString stringWithFormat:@"%ld",anno.anTag]];
        
        
        return annotationView;
    }
    return nil;
}
- (UIImage *)addNumImages:(UIImage *)oldImageView andText:(NSString *)text{
    //UIGraphicsBeginImageContext(CGSizeMake(25, 30));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, [UIScreen mainScreen].scale);
    [oldImageView drawInRect:CGRectMake(0, 0, 30, 30)];
    CGRect rect = CGRectMake(0, 0, 30, 30);
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:13];
    NSString *str = text;
    textLabel.text = str;
    textLabel.numberOfLines = 1;//根据最大行数需求来设置
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    //关键语句
    rect.origin.x = 15 - (expectSize.width * 0.5);
    rect.origin.y = 15 - (expectSize.height * 0.5) - 3;
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
