//
//  ArearViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/11.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ArearViewController.h"
#import "AddAddressViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ArearViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (nonatomic, strong) CLGeocoder *geoC;
@property (nonatomic, strong) UITableView *arearTableView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) NSString *currentname;
@end

@implementation ArearViewController
- (NSString *)resultStr {
    if (!_resultStr) {
        _resultStr = @"";
    }
    return _resultStr;
}
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.title.length == 0) {
        self.title = @"选择位置";
    }
    
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    [self setUP];
    if (!self.myData) {
        [self getData];
    }
    [self setupLocation];
    
}
- (void)setupLocation {
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}
- (void)getData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/config/getRegion.do" params:nil withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        self.myData = [showdata copy];
        [self.arearTableView reloadData];
    }];
}
- (void)setUP {
    self.arearTableView = [[UITableView alloc]init];
    [self.view addSubview:self.arearTableView];
    self.arearTableView.backgroundColor = [UIColor whiteColor];
    [self.arearTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.view.mas_top).with.offset(navHight + 65);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
    }];
    LRViewBorderRadius(self.arearTableView, 5, 0, [UIColor clearColor]);
    self.arearTableView.delegate = self;
    self.arearTableView.dataSource = self;
    UIView *locationView = [[UIView alloc]init];
    locationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:locationView];
    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.top.equalTo(self.view.mas_top).with.offset(navHight + 10);
        make.height.equalTo(@45);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [locationView addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(select)];
    LRViewBorderRadius(locationView, 5, 0, [UIColor clearColor]);
    UILabel *locationlabel = [[UILabel alloc]init];
    self.locationLabel = locationlabel;
    [locationView addSubview:locationlabel];
    [locationlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationView.mas_left).with.offset(10);
        make.centerY.equalTo(locationView.mas_centerY);
    }];
    locationlabel.text = @"当前位置：";
}
- (void)select {
    if (self.block) {
        self.block(self.currentname);
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[AddAddressViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.myData isKindOfClass:[NSArray class]]) {
        return self.myData.count;
    }
    return [[self.myData allKeys] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if ([self.myData isKindOfClass:[NSArray class]]) {
        cell.textLabel.text = ((NSArray *)self.myData)[indexPath.row];
    } else {
        cell.textLabel.text = self.myData.allKeys[indexPath.row];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArearViewController *area = [ArearViewController new];
    if ([self.myData isKindOfClass:[NSDictionary class]]) {
        area.myData = self.myData.allValues[indexPath.row];
    }
    
    if ([self.myData isKindOfClass:[NSArray class]]) {
        area.title = ((NSArray *)self.myData)[indexPath.row];
        if (self.block) {
            self.block([self.resultStr stringByAppendingString:((NSArray *)self.myData)[indexPath.row]]);
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[AddAddressViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        NSLog(@"%@",[self.resultStr stringByAppendingString:((NSArray *)self.myData)[indexPath.row]]);
    } else {
        area.title = self.myData.allKeys[indexPath.row];
        area.resultStr = [self.resultStr stringByAppendingString:[self.myData.allKeys[indexPath.row] stringByAppendingString:@","]];
        area.block = self.block;
        [self.navigationController pushViewController:area animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -- locationDelegae
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    
    //self.currentLocation = location.coordinate;
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    
    CLLocation *locations = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geoC reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *pl = [placemarks firstObject];
        
        if(error == nil)
        {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            self.currentname = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.subLocality];
            NSLog(@"%@", pl.name);
            self.locationLabel.text = [NSString stringWithFormat:@"当前位置：%@ %@",pl.locality,pl.subLocality];
//            self.addressTV.text = pl.name;
//            self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
//            self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
        }
    }];
    
}


@end
