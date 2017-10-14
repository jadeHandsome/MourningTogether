//
//  LocationViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/12.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ImageCenterButton.h"
#import "RailViewController.h"
#import "TRAnnotation.h"
#import "TrackViewController.h"
@interface LocationViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@end

@implementation LocationViewController
{
    NSInteger locationUpdata;
    MACircle *circle;
    TRAnnotation *pointAnnotation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    locationUpdata = 1;
    self.navigationItem.title = @"位置";
    [self setUPMap];
    [self setBottomView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self getLocation];
}
//获取位置信息
- (void)getLocation {
    NSString *deviceId = @"";
    if ([KRUserInfo sharedKRUserInfo].deviceId) {
        deviceId = [KRUserInfo sharedKRUserInfo].deviceId;
    }
    [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:@"/device/getPositionFenceInfo.do" params:@{@"deviceId":deviceId} withModel:nil complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            [self.mapView setCenterCoordinate:self.currentLocation animated:YES];
            return ;
        }
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake( [showdata[@"fenceLatitude"] doubleValue],[showdata[@"fenceLongitude"] doubleValue]);
        CGFloat r = [showdata[@"fenceSize"] floatValue];
        [_mapView removeOverlay:circle];
        
        
        circle = [MACircle circleWithCenterCoordinate:location radius:r];
        pointAnnotation  = [[TRAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([showdata[@"latitude"] doubleValue], [showdata[@"longitude"] doubleValue]);
        pointAnnotation.image = [UIImage imageNamed:@"云医时代-75"];
        [self.mapView removeOverlay:circle];
        [self.mapView removeAnnotation:pointAnnotation];
        
        [self.mapView addAnnotation:pointAnnotation];
        [self.mapView addOverlay:circle];
        [self.mapView setCenterCoordinate:location animated:YES];
        NSLog(@"%@",showdata);
    }];
}
- (void)setUPMap {
    
    _mapView = [[MAMapView alloc] init];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    

//    self.mapView.showsUserLocation = YES;
//    _mapView.logoCenter = CGPointMake(0, 0);
//    [_mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    ///把地图添加至view
    //_mapView.mapType = MAMapTypeSatellite;
    _mapView.delegate = self;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.mapView setZoomLevel:12 animated:YES];
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-75);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
    }];
}
- (void)setBottomView {
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@75);
    }];
    ImageCenterButton *leftBtn = [[ImageCenterButton alloc]init];
    [bottomView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.top.equalTo(bottomView.mas_top);
        make.bottom.equalTo(bottomView.mas_bottom);
    }];
    [leftBtn setImage:[UIImage imageNamed:@"云医时代-69"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"足迹" forState:UIControlStateNormal];
    [leftBtn setTitleColor:LRRGBColor(223, 103, 113) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(guijiClick) forControlEvents:UIControlEventTouchUpInside];
    ImageCenterButton *rightBtn = [[ImageCenterButton alloc]init];
    [bottomView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(bottomView.mas_top);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.right.equalTo(bottomView.mas_right);
        make.width.equalTo(leftBtn.mas_width);
    }];
    [rightBtn setImage:[UIImage imageNamed:@"云医时代-70"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"栅栏" forState:UIControlStateNormal];
    [rightBtn setTitleColor:LRRGBColor(144, 219, 79) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(railClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)guijiClick {
    //去轨迹
    TrackViewController *track = [[TrackViewController alloc]init];
    [self.navigationController pushViewController:track animated:YES];
}
- (void)railClick {
    //去围栏
    RailViewController *rail = [[RailViewController alloc]init];
    [self.navigationController pushViewController:rail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    
    self.currentLocation = location.coordinate;
    //在地图上添加圆
    //[_mapView addOverlay: circle];
//    if (locationUpdata == 1) {
//        [self.mapView setCenterCoordinate:self.currentLocation animated:YES];
//    }
    //locationUpdata ++;
}
#pragma -- amapDelegate
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
