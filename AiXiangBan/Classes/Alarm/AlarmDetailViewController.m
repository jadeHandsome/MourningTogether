//
//  AlarmDetailViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AlarmDetailViewController.h"
#import "AlarmBtnView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "TRAnnotation.h"
#import "AskHelpViewController.h"
#import "UIImage+Gif.h"
@interface AlarmDetailViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation AlarmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.navigationItem.title = @"紧急报警";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    [self setUp];
    [self loadData];
}
- (void)loadData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/emergency/getEmergencyInfo.do" params:@{@"emergencyId":self.alarmId} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake( [showdata[@"latitude"] doubleValue],[showdata[@"longitude"] doubleValue]);
        
        
        
        
        TRAnnotation *pointAnnotation  = [[TRAnnotation alloc] init];
        pointAnnotation.coordinate = location;
        pointAnnotation.image = [UIImage imageNamed:@"云医时代-75"];
        
        [self.mapView addAnnotation:pointAnnotation];
        [self.mapView setCenterCoordinate:location animated:YES];
    }];
}
- (void)pop {
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)setUp {
    self.mainScroll = [[UIScrollView alloc]init];
    [self.view addSubview:self.mainScroll];
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-navHight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = ColorRgbValue(0x1cb9cf);
    [self.mainScroll addSubview:blueView];
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScroll.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@160);
    }];
    
    UIView *centerView = [[UIView alloc]init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.top.equalTo(self.mainScroll.mas_top).with.offset(navHight + 20);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@400);
    }];
    LRViewBorderRadius(centerView, 5, 0, [UIColor clearColor]);
    NSArray *array = @[[UIImage imageNamed:@"图层1"],[UIImage imageNamed:@"图层2"],[UIImage imageNamed:@"图层3"]];
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.contentMode = UIViewContentModeCenter;
    headImage.animationImages = array;
    headImage.animationDuration = 1;
    headImage.animationRepeatCount = 100000;
    [headImage startAnimating];
    
    
    [centerView addSubview:headImage];
    [self.view bringSubviewToFront:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_top);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
        make.height.equalTo(@260);
    }];
    UIView *line = [[UIView alloc]init];
    [centerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_bottom);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(230, 230, 230);
    
    AlarmBtnView *btnView = [[[NSBundle mainBundle]loadNibNamed:@"AlarmBtnView" owner:self options:nil]firstObject];
    [centerView addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(centerView.mas_bottom);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
    }];
    __weak typeof(self) weakSelf = self;
    btnView.block = ^(NSInteger tag) {
      //100 我去处理 101 紧急求助 102 解除报警 103 紧急联络
        NSInteger type = 1;
        switch (tag) {
            case 100:
            {
                type = 1;
                [weakSelf alarmFinish:type];
            }
                break;
            case 101:
            {
                type = 3;
                [weakSelf alarmFinish:type];
            }
                break;
            case 102:
            {
                type = 2;
                [weakSelf alarmFinish:type];
            }
                break;
            case 103:
            {
                [weakSelf goCall];
            }
                break;
                
            default:
                break;
        }
        
    
    };
    UIView *line2 = [[UIView alloc]init];
    [self.mainScroll addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom).with.offset(160);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    line2.backgroundColor = LRRGBColor(230, 230, 230);
    UIView *bottomView = [[UIView alloc]init];
    [self.mainScroll addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@370);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(line2.mas_bottom);
        
    }];
    self.mainScroll.contentSize = CGSizeMake(0, navHight + 20 + 400 + 160 + 1 + 370 - navHight);
    UILabel *label = [[UILabel alloc]init];
    label.text = @"下拉查看位置>>";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = ColorRgbValue(0x1cb9cf);
    [bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).with.offset(-10);
        make.height.equalTo(@20);
        make.top.equalTo(bottomView.mas_top);
    }];
    
    _mapView = [[MAMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;
    [self.mapView setZoomLevel:12 animated:YES];
    [bottomView addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(-75);
        make.top.equalTo(label.mas_bottom);
    }];
}
- (void)alarmFinish:(NSInteger)type {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/emergency/dealEmergency.do" params:@{@"emergencyId":self.alarmId,@"deal":@(type)} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (void)goCall {
    AskHelpViewController *ask = [[AskHelpViewController alloc]init];
    [self.navigationController pushViewController:ask animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[TRAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
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
