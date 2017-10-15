//
//  ControllRobotViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/14.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ControllRobotViewController.h"
#import "SocketTool.h"
#import "AppDelegate.h"
#import "BaseNaviViewController.h"
#import "ControllView.h"
#import "RoailView.h"
@interface ControllRobotViewController ()<TcpManagerDelegate>
@property (nonatomic, strong) SocketTool *sockManager;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ControllView *controllView;
@end

@implementation ControllRobotViewController
- (SocketTool *)sockManager {
    if (!_sockManager) {
        _sockManager = [SocketTool Share];
        _sockManager.delegate = self;
        if (![_sockManager.asyncsocket connectToHost:@"47.92.87.19" onPort:9346 error:nil]) {
            
            NSLog(@"fail to connect");
            
        }
    }
    return _sockManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
}
- (void)setUp {
    UIButton *popBtn = [[UIButton alloc]init];
    [self.view addSubview:popBtn];
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.width.equalTo(@100);
    }];
    [popBtn setImage:[UIImage imageNamed:@"云医时代1-22"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIButton *openBtn = [[UIButton alloc]init];
    [self.view addSubview:openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popBtn.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
    }];
    [openBtn setTitleColor:LRRGBColor(0, 188, 210) forState:UIControlStateNormal];
    [openBtn setTitle:@"开启摄像头" forState:UIControlStateNormal];
     LRViewBorderRadius(openBtn, 0, 1, LRRGBColor(0, 188, 210));
    [openBtn addTarget:self action:@selector(openBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *closeBtn = [[UIButton alloc]init];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(openBtn.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
    }];
    [closeBtn setTitleColor:LRRGBColor(0, 188, 210) forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭摄像头" forState:UIControlStateNormal];
    LRViewBorderRadius(closeBtn, 0, 1, LRRGBColor(0, 188, 210));
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    ControllView *cont = [[[NSBundle mainBundle]loadNibNamed:@"ControllView" owner:self options:nil]firstObject];
    self.controllView = cont;
    [self.view addSubview:cont];
    cont.block = ^(NSInteger tag) {
        switch (tag) {
            case 1:
            {
                //向前
                NSLog(@"向前");
            }
                break;
            case 2:
            {
                //向后
                NSLog(@"向后");
            }
                break;
            case 3:
            {
                //向左
                NSLog(@"向左");
            }
                break;
            case 4:
            {
                //向右
                NSLog(@"向右");
            }
                break;
            case 5:
            {
                //暂停
                NSLog(@"暂停");
            }
                break;
                
            default:
                break;
        }
    };
    cont.userInteractionEnabled = NO;
    [cont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@200);
        make.height.equalTo(@200);
    }];
    RoailView *rail = [[[NSBundle mainBundle]loadNibNamed:@"RoailView" owner:self options:nil]firstObject];
    [self.view addSubview:rail];
    rail.block = ^(CGFloat f) {
      //改变角度
    };
    [rail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.equalTo(@195);
        make.height.equalTo(@137.5);
    }];
}
- (void)openBtnClick {
    //开启摄像头
    
    
}
- (void)closeBtnClick {
    //关闭摄像头
    
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark 横屏设置

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //强制旋转竖屏
    [self forceOrientationLandscape];
    BaseNaviViewController *navi = (BaseNaviViewController *)self.navigationController;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    navi.interfaceOrientation =   UIInterfaceOrientationLandscapeRight;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //强制旋转竖屏
    [self forceOrientationPortrait];
    BaseNaviViewController *navi = (BaseNaviViewController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}



#pragma  mark 横屏设置
//强制横屏
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


#pragma -- TcpManagerDelegate
//获取到数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"获取完成");
}
//写入数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"写入完成");
}
//链接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"链接成功了");
}
//断开链接

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"断开链接了");
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
