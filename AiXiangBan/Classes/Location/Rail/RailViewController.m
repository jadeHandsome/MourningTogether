//
//  RailViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/13.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "CustomSliderView.h"
#import "TRAnnotation.h"
#import <CoreLocation/CoreLocation.h>
@interface RailViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UILabel *roatLabel;
@property (nonatomic, strong) CustomSliderView *slider;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CLLocationCoordinate2D railCenter;
@property (nonatomic, strong) MACircle *circle;
@property (nonatomic, strong) CLGeocoder *geoC;
@property (nonatomic, strong) TRAnnotation *anno;
@end

@implementation RailViewController
{
    NSInteger locationUpdata;
    
    //MACircle *circle;
}
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
- (TRAnnotation *)anno {
    if (!_anno) {
        _anno = [[TRAnnotation alloc] init];
        self.anno.coordinate = CLLocationCoordinate2DMake(0, 0);
        self.anno.image = [UIImage imageNamed:@"云医时代-75"];
    }
    return _anno;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.value = 500;
    self.navigationItem.title = @"设置围栏";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    [self setUP];
    [self getData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick)];

}
- (void)saveClick {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"deviceId"] = [KRUserInfo sharedKRUserInfo].deviceId;
    param[@"longitude"] = @(self.railCenter.longitude);
    param[@"latitude"] = @(self.railCenter.latitude);
    param[@"size"] = @((int)self.value/1000.0);
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/device/setFenceInfo.do" params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:@"设置成功" toView:self.view.window];
    }];
}
- (void)setupLocation {
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}
//获取围栏信息
- (void)getData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/device/getPositionFenceInfo.do" params:@{@"deviceId":[KRUserInfo sharedKRUserInfo].deviceId} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
//        dateTime
//        longitude
//        latitude
//        fenceLongitude
//        fenceLatitude
//        fenceSize
        self.value = [showdata[@"fenceSize"] floatValue] * 1000;
        self.slider.vaule = self.value;
        [self.slider setUpV];
        self.railCenter = CLLocationCoordinate2DMake( [showdata[@"fenceLatitude"] doubleValue],[showdata[@"fenceLongitude"] doubleValue]);
        
        CGFloat r = [showdata[@"fenceSize"] floatValue] * 1000;
        self.circle = [MACircle circleWithCenterCoordinate:self.railCenter radius:r];
        self.anno  = [[TRAnnotation alloc] init];
        self.anno.coordinate = CLLocationCoordinate2DMake([showdata[@"latitude"] doubleValue], [showdata[@"longitude"] doubleValue]);
        self.anno.image = [UIImage imageNamed:@"云医时代-75"];
        [self.mapView addAnnotation:self.anno];
        [self.mapView addOverlay:self.circle];
        [self.mapView setCenterCoordinate:self.railCenter animated:YES];
        
        
        CLLocation *locations = [[CLLocation alloc] initWithLatitude:self.railCenter.latitude longitude:self.railCenter.longitude];
        
        [self.geoC reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *pl = [placemarks firstObject];
            
            if(error == nil)
            {
                NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
                //self.currentname = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.subLocality];
                NSLog(@"%@", pl.name);
                self.locationLabel.text = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.subLocality];
                //            self.addressTV.text = pl.name;
                //            self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
                //            self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
            }
        }];
        
    }];
}
- (void)setUP {
    UIView *titleView = [[UIView alloc]init];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(navHight + 10);
        make.height.equalTo(@91);
        make.right.equalTo(self.view.mas_right);
        
    }];
    UILabel *topLabel = [[UILabel alloc]init];
    [titleView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).with.offset(15);
        make.height.equalTo(@45);
        make.top.equalTo(titleView.mas_top);
        
    }];
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.text = @"围栏中心";
    UIView *line = [[UIView alloc]init];
    [titleView addSubview:line];
    titleView.backgroundColor = [UIColor whiteColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.top.equalTo(topLabel.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(titleView.mas_right).with.offset(-10);
    }];
    line.backgroundColor = LRRGBColor(233, 233, 233);
    UILabel *locationLabel = [[UILabel alloc]init];
    [titleView addSubview:locationLabel];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).with.offset(10);
        make.top.equalTo(line.mas_bottom);
        make.height.equalTo(@45);
        
    }];
    self.locationLabel = locationLabel;
    locationLabel.font = [UIFont systemFontOfSize:15];
    UIView *bottomView = [[UIView alloc]init];
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(titleView.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    UILabel *roatLabel = [[UILabel alloc]init];
    [bottomView addSubview:roatLabel];
    [roatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).with.offset(10);
        make.height.equalTo(@45);
        make.top.equalTo(bottomView.mas_top);
    }];
    roatLabel.font = [UIFont systemFontOfSize:14];
    roatLabel.text = @"围栏半径";
    _roatLabel = roatLabel;
    UIView *line1 = [[UIView alloc]init];
    [bottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.top.equalTo(roatLabel.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(bottomView.mas_right).with.offset(-10);
    }];
    line.backgroundColor = LRRGBColor(233, 233, 233);
    UIView *sliderView = [[UIView alloc]init];
    [bottomView addSubview:sliderView];
    [sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.top.equalTo(line1.mas_bottom);
        make.height.equalTo(@60);
        make.right.equalTo(bottomView.mas_right);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    UILabel *leftLabel = [[UILabel alloc]init];
    [sliderView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sliderView.mas_left).with.offset(10);
        make.bottom.equalTo(sliderView.mas_bottom);
        make.height.equalTo(@30);
    }];
    leftLabel.font = [UIFont systemFontOfSize:13];
    leftLabel.textColor = LRRGBColor(162, 162, 162);
    leftLabel.text = @"500M";
    
    UILabel *rightLabel = [[UILabel alloc]init];
    [sliderView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sliderView.mas_right).with.offset(-10);
        make.bottom.equalTo(sliderView.mas_bottom);
        make.height.equalTo(@30);
    }];
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.textColor = LRRGBColor(162, 162, 162);
    rightLabel.text = @"10KM";
    
    CGSize leftF = [KRBaseTool getNSStringSize:@"500M" andViewWight:2000 andFont:13];
    CGSize rightF = [KRBaseTool getNSStringSize:@"10KM" andViewWight:2000 andFont:13];
    
    self.slider = [[NSBundle mainBundle]loadNibNamed:@"CustomSliderView" owner:self options:nil].firstObject;
    [sliderView addSubview:self.slider];
    __weak typeof(self) weakSelf = self;
    
    self.slider.block = ^(CGFloat f) {
        weakSelf.value = f;
        
        [weakSelf.mapView removeOverlay:weakSelf.circle];
        
        weakSelf.circle = [MACircle circleWithCenterCoordinate:weakSelf.railCenter radius:f];
        [weakSelf.mapView addOverlay:weakSelf.circle];
    };
    self.slider.vaule = self.value;
    [self.slider setUpV];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sliderView.mas_left).with.offset(10 + leftF.width * 0.5);
        make.right.equalTo(sliderView.mas_right).with.offset(-(10 + rightF.width * 0.5));
        make.bottom.equalTo(leftLabel.mas_top);
        make.height.equalTo(@30);
    }];
    
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
        make.top.equalTo(sliderView.mas_bottom);
    }];
    UITapGestureRecognizer *lpress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.delegate = self;
    [_mapView addGestureRecognizer:lpress];
    
}
- (void)longPress:(UITapGestureRecognizer *)tap {
    [_mapView removeAnnotation:self.anno];
    //坐标转换
    CGPoint touchPoint = [tap locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    self.railCenter = touchMapCoordinate;
    self.anno.coordinate = touchMapCoordinate;
    
    //_pointAnnotation.title = @"设置名字";
    
    [_mapView addAnnotation:self.anno];
    CLLocation *locations = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    
    [self.geoC reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *pl = [placemarks firstObject];
        
        if(error == nil)
        {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            //self.currentname = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.subLocality];
            NSLog(@"%@", pl.name);
            self.locationLabel.text = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.subLocality];
            //            self.addressTV.text = pl.name;
            //            self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
            //            self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
        }
    }];
    //[self setLocationWithLatitude:touchMapCoordinate.latitude AndLongitude:touchMapCoordinate.longitude];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -- locationDelegae
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 5.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:132.0/255 green:235.0/255 blue:245.0/255 alpha:0.8];
        circleRenderer.fillColor    = [UIColor colorWithRed:132.0/255 green:235.0/255 blue:245.0/255 alpha:0.5];
        return circleRenderer;
    }
    return nil;
}
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
