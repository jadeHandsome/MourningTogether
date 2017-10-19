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
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GCDAsyncSocket.h"

#define LIVE_URL  @"rtmp://live.xxb99.cn/xxb/"
@interface ControllRobotViewController ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) SocketTool *sockManager;
@property (nonatomic, strong) ControllView *controllView;
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) AliVcMediaPlayer* mediaPlayer;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) ControllView *directionView;
@property (nonatomic, strong) RoailView *railView;
@end

@implementation ControllRobotViewController
{
    MBProgressHUD *hud;
    BOOL isPlaye;
    NSInteger loadCount;
    NSTimer *countTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMeid];
    [self setUp];
    [self setProgressViewData];
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.socket connectToHost:@"47.92.87.19" onPort:9346 error:nil];
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeHome:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];

    loadCount = 0;
    
}
- (void)comeHome:(UIApplication *)application {
    NSLog(@"进入后台");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"程序被杀死");
    [self closeLive];
}

- (void)setProgressViewData {
    self.progressView = [[UIView alloc]init];
    self.progressView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.progressView.hidden = YES;
}
- (void)setUpMeid {
    self.mediaPlayer = [[AliVcMediaPlayer alloc] init];
    [self.mediaPlayer create:self.view];
    
    self.mediaPlayer.mediaType = MediaType_AUTO;
    self.mediaPlayer.timeout = 10000;//毫秒
    //self.mediaPlayer.dropBufferDuration = [self.dropBufferDurationTextField.text intValue];
    //注册准备完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoPrepared:) name:AliVcMediaPlayerLoadDidPreparedNotification object:nil];
    //注册错误通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoError:) name:AliVcMediaPlayerPlaybackErrorNotification object:nil];
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
    self.directionView = cont;
    [self.view addSubview:cont];
    cont.block = ^(NSInteger tag) {
        switch (tag) {
            case 1:
            {
                //向前
                NSLog(@"向前");
                [self goAhead];
            }
                break;
            case 2:
            {
                //向后
                NSLog(@"向后");
                [self goBack];
            }
                break;
            case 3:
            {
                //向左
                NSLog(@"向左");
                [self goLeft];
            }
                break;
            case 4:
            {
                //向右
                NSLog(@"向右");
                [self goRight];
            }
                break;
            case 5:
            {
                //暂停
                NSLog(@"暂停");
                [self stopMove];
            }
                break;
                
            default:
                break;
        }
    };
    //cont.userInteractionEnabled = NO;
    [cont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@200);
        make.height.equalTo(@200);
    }];
    
    RoailView *rail = [[[NSBundle mainBundle]loadNibNamed:@"RoailView" owner:self options:nil]firstObject];
    self.railView = rail;
    [self.view addSubview:rail];
    rail.block = ^(CGFloat f) {
      //改变角度
        if (f < 0) {
            [self headMoveLeft];
        } else {
            [self headMoveRight];
        }
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
    if (isPlaye) {
        [self showHUDWithText:@"已经开启，无需重复开启"];
        return;
    }
    isPlaye = YES;
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        countTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            loadCount ++;
            if (loadCount >= 60) {
                [timer invalidate];
                weakSelf.progressView.hidden = YES;
                [hud hideAnimated:YES];
                isPlaye = NO;
                [self showHUDWithText:@"请求超时"];
                loadCount = 0;
            }
            
        }];
    } else {
        // Fallback on earlier versions
    }
    hud  = [MBProgressHUD showMessage:@"正在开启" toView:self.view.window];
    self.progressView.hidden = NO;
    [self showHUDWithText:@"正在开启"];
    [self logIn];
    
}
- (void)closeBtnClick {
    //关闭摄像头
    if (!isPlaye) {
      [self showHUDWithText:@"已经关闭，无需重复关闭"];
        return;
    }
    isPlaye = NO;
    [self closeLive];
    
    
}

- (void)pop {
    [self closeLive];
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isFull = YES;
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isFull = NO;
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    [self closeLive];
}



- (NSString *)setPostProtocolWithCmid:(NSString *)cmid andSn:(NSString *)sn andParams:(NSString *)params {
//    if (params == 0) {
//        return nil;
//    }
    NSInteger lenth = params.length;
    NSMutableString *potocol = [NSMutableString string];
    [potocol appendString:@"groupcode=xxs"];
    [potocol appendString:@"&version=01"];
    [potocol appendString:@"&type=01"];
    [potocol appendFormat:@"&cmdid=%@",cmid];
    [potocol appendFormat:@"&transationid=%@",@"00000001"];
    [potocol appendFormat:@"&sn=%@",self.robotId];
    [potocol appendString:@"&reserved=0000"];
    [potocol appendString:@"&type=01"];
    [potocol appendFormat:@"&length=%04ld",lenth];
    if (params) {
        [potocol appendString:params];
    }
    [potocol appendString:@"&error=00000000\n"];
    return [potocol copy];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}

#pragma -- TcpManagerDelegate
//获取到数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"获取完成");
    NSString *recevied = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",recevied);
    //开启成功
    if (tag == 1) {
        NSString *recevied = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",recevied);
        NSArray *strArray = [recevied componentsSeparatedByString:@"&"];
        for (NSString *str in strArray) {
            if ([str containsString:@"reserved"]) {
                if ([str containsString:@"0001"]) {
                    //有人控制 只能观看
                    [hud hideAnimated:YES];
                    self.progressView.hidden = YES;
                    self.directionView.hidden = YES;
                    self.railView.hidden = YES;
                    [self.mediaPlayer prepareToPlay:[NSURL URLWithString:[LIVE_URL stringByAppendingString:_robotId]]];
                    [self.mediaPlayer play];
                } else if ([str containsString:@"0000"]) {
                    //正常
                    
                    self.directionView.hidden = NO;
                    self.railView.hidden = NO;
                    [self beginLive];
                }
            }
        }
    } else if (tag == 13) {
        
        NSString *recevied = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",recevied);
        
        if (![recevied containsString:@"&cmdid=00000020"]) {
            
            [self.socket readDataWithTimeout:30 tag:13];
            return;
        }
        [countTimer invalidate];
        NSArray *strArray = [recevied componentsSeparatedByString:@"&"];
        for (NSString *str in strArray) {
            if ([str containsString:@"reserved"]) {
                [hud hideAnimated:YES];
                self.progressView.hidden = YES;
                if ([str containsString:@"1000"]) {
                    //推流成功
                    NSLog(@"推流成功");
                    [self performSelector:@selector(openMedil) withObject:nil afterDelay:2];
                    
                } else if ([str containsString:@"2000"]) {
                    //断流成功
                    
                    
                } else if ([str containsString:@"3000"]) {
                    //失败
                    NSLog(@"推流失败");
                    [self showHUDWithText:@"机器人推流失败"];
                    
                }
            }
        }
    }
    
    //NSDictionary *data = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
   
}
- (void)openMedil {
    [self.mediaPlayer prepareToPlay:[NSURL URLWithString:[LIVE_URL stringByAppendingString:_robotId]]];
    [self.mediaPlayer play];
}
//开始直播
- (void)beginLive {
    NSLog(@"开启视屏流");
   NSString *param = [self setPostProtocolWithCmid:@"00000013" andSn:nil andParams:nil];
    [self sendMessageWith:param andtag:13];
    
}
-(void) OnVideoPrepared:(NSNotification *)notification
{
    //收到完成通知后，获取视频的相关信息，更新界面相关信息
//    [self.playSlider setMinimumValue:0];
//    [self.playSlider setMaximumValue:player.duration];
    NSLog(@"准备完成");
}
-(void)OnVideoError:(NSNotification *)notification
{
    NSLog(@"播放出错");
    //[self.mediaPlayer play];
    //AliVcMovieErrorCode error_code = player.errorcode;
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
    [self.socket connectToHost:@"47.92.87.19" onPort:9346 error:nil];
}
//登录
- (void)logIn {
    NSString *params = [self setPostProtocolWithCmid:@"01000001" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:1];
}
//打开直播
- (void)openLive {
    NSString *params = [self setPostProtocolWithCmid:@"01000001" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:2];
}
//关闭直播
- (void)closeLive {
    NSString *params = [self setPostProtocolWithCmid:@"00000015" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:3];
}
//向前走
- (void)goAhead {
    NSString *params = [self setPostProtocolWithCmid:@"00000009" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:4];
   
}
//向后走
- (void)goBack {
    NSString *params = [self setPostProtocolWithCmid:@"0000000B" andSn:nil andParams:nil];
   [self sendMessageWith:params andtag:5];
}
//向左走
- (void)goLeft {
    NSString *params = [self setPostProtocolWithCmid:@"0000000D" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:6];
}
//向右走
- (void)goRight {
    NSString *params = [self setPostProtocolWithCmid:@"0000000F" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:7];
}
//旋转角度
- (void)roal {
    NSString *params = [self setPostProtocolWithCmid:@"00000005" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:8];
}
//头左
- (void)headMoveLeft {
    NSString *params = [self setPostProtocolWithCmid:@"00000005" andSn:nil andParams:@"&speed=0"];
    [self sendMessageWith:params andtag:9];
}
//头右
- (void)headMoveRight {
    NSString *params = [self setPostProtocolWithCmid:@"00000003" andSn:nil andParams:@"&speed=0"];
    [self sendMessageWith:params andtag:10];
}
//停止移动
- (void)stopMove {
    NSString *params = [self setPostProtocolWithCmid:@"00000011" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:11];
}
//退出登录
- (void)logOut {
    NSString *params = [self setPostProtocolWithCmid:@"00000011" andSn:nil andParams:nil];
    [self sendMessageWith:params andtag:12];
}
- (void)sendMessageWith:(NSString *)str andtag:(long)tag {
    NSData   *data  = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:3 tag:tag];
    [self.socket readDataWithTimeout:30 tag:tag];
}





@end
