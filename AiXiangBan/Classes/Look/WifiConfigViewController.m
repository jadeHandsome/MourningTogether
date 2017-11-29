//
//  WifiConfigViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/11/28.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "WifiConfigViewController.h"
typedef enum _DEVICE_STATE
{
    STATE_NONE = 0,          // 设备状态-无
    STATE_WIFI,              // wifi已连接
    STATE_LINE,              // 有线已连接
    STATE_PLAT,              // 平台已注册
    STATE_SUCC,              // 已添加成功
} DEVICE_STATE;
@interface WifiConfigViewController ()
{
    NSTimer *_countTimer;
    
    NSTimeInterval _interval;
}
@property (nonatomic, strong) UIImageView *timerImageView; //添加设备操作有效时间视图
@property (nonatomic, strong) UIView *failedTipsView; //添加失败提示视图
@property (nonatomic, strong) UIImageView *successWifiImageView;  //Wi-Fi成功标签图
@property (nonatomic, strong) UIImageView *successRegisterImageView; //注册成功标签图
@property (nonatomic, strong) UIImageView *animationImageView; //添加设备动画视图
@property (nonatomic, strong) UIView *addTipsView; //添加设备阶段提示视图
@property (nonatomic, strong) UIButton *helpButton; //帮助链接按钮

@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) UILabel *registerLabel;
@property (nonatomic, strong) UILabel *bindLabel;

@property (nonatomic, strong) UILabel *completionLabel;
@property (nonatomic, strong) UIButton *completionButton; //设备添加完成按钮

@property (nonatomic) DEVICE_STATE enState;
@end

@implementation WifiConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第三步，添加设备";
    // key为空可以传个任意字符过去
    if ([self.password length] == 0)
    {
        self.password = nil;
    }
    
    [self wifiConfigStart];
    // Do any additional setup after loading the view.
}

- (void)wifiConfigStart
{
    if(!_isAddDeviceSuccessed)
    {
        [self createAddDeviceInitView];
        
        __weak typeof(self) weakSelf = self;
        
        [EZOPENSDK startConfigWifi:weakSelf.ssid
                          password:weakSelf.password
                      deviceSerial:self.deviceSerialNo
                      deviceStatus:^(EZWifiConfigStatus status) {
                          if (status == DEVICE_WIFI_CONNECTING)
                          {
                              weakSelf.enState = STATE_NONE;
                              [weakSelf createTimerWithTimeOut:60];
                          }
                          else if (status == DEVICE_WIFI_CONNECTED)
                          {
                              if(weakSelf.enState != STATE_WIFI){
                                  weakSelf.enState = STATE_WIFI;
                                  [weakSelf createTimerWithTimeOut:60];
                              }
                          }
                          else if (status == DEVICE_PLATFORM_REGISTED)
                          {
                              weakSelf.enState = STATE_PLAT;
                              [weakSelf createTimerWithTimeOut:30];
                              if(self.deviceVerifyCode != nil)
                              {
                                  [EZOPENSDK addDevice:self.deviceSerialNo
                                            verifyCode:self.deviceVerifyCode
                                            completion:^(NSError *error) {
                                                [weakSelf handleTheError:error];
                                            }];
                              }
                              else
                              {
                                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"请输入设备验证码" message:@"" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                  alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                                  alertView.tag = 0xaa;
                                  [alertView show];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      if ([_countTimer isValid])
                                      {
                                          [_countTimer invalidate];
                                          _countTimer = nil;
                                      }
                                  });
                              }
                          }
                      }];
    }
    else
    {
        [self createAddDeviceInitView];
        
        _enState = STATE_SUCC;
        [self showTipsView];
    }
}


- (void)createTimerWithTimeOut:(NSInteger)timeout
{
    if ([_countTimer isValid])
    {
        [_countTimer invalidate];
        _countTimer = nil;
    }
    
    _interval = timeout; //各阶段UI显示时间
    UILabel *timeLabel = (UILabel *)[self.timerImageView viewWithTag:0x11c];
    timeLabel.text = [NSString stringWithFormat:@"%d",(int)timeout];
    
    [self showTipsView];
    
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                   target:self
                                                 selector:@selector(countDownBindDevice)
                                                 userInfo:nil
                                                  repeats:YES];
}

/**
 * 各阶段倒计时控制
 **/
- (void)countDownBindDevice
{
    _interval--;
    
    if (_interval < 0)
    {
        _interval = 0;
        
        if ([_countTimer isValid])
        {
            [_countTimer invalidate];
            _countTimer = nil;
        }
        
        //超时以后查询一次设备信息
        [EZOPENSDK probeDeviceInfo:self.deviceSerialNo
                        completion:^(EZProbeDeviceInfo *deviceInfo, NSError *error) {
                            if (error)
                            {
                                //有错误直接显示错误的UI
                                [self showFailedView];
                            }
                            else
                            {
                                if (self.deviceVerifyCode != nil)
                                {
                                    [EZOPENSDK addDevice:self.deviceSerialNo
                                              verifyCode:self.deviceVerifyCode
                                              completion:^(NSError *error) {
                                                  
                                                  [self handleTheError:error];
                                                  
                                                  if (error)
                                                  {
                                                      [self showFailedView];
                                                  }
                                              }];
                                }
                                else
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入设备验证码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                                    alertView.tag = 0xaa;
                                    [alertView show];
                                }
                            }
                        }];
    }
    
    UILabel *timeLabel = (UILabel *)[self.timerImageView viewWithTag:0x11c];
    timeLabel.text = [NSString stringWithFormat:@"%d",(int)_interval];
}

/*
 * 设备添加初始界面构造
 */
- (void)createAddDeviceInitView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wifi_bg"]];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHight);
    }];
    
    [self.view addSubview:self.animationImageView];
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navHight);
        make.leading.trailing.mas_equalTo(@0);
        make.height.mas_equalTo(@(185 * [UIScreen mainScreen].bounds.size.width/320.0f));
    }];
    
    if (STATE_LINE == _enState)
    {
        // 动画image
        self.animationImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"link_account1"],
                                                   [UIImage imageNamed:@"link_account2"],
                                                   [UIImage imageNamed:@"link_account3"],
                                                   [UIImage imageNamed:@"link_account4"],
                                                   nil];
    }
    else
    {
        
        
        // 动画image
        self.animationImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"connect_wifi1"],
                                                   [UIImage imageNamed:@"connect_wifi2"],
                                                   [UIImage imageNamed:@"connect_wifi3"],
                                                   [UIImage imageNamed:@"connect_wifi4"],
                                                   nil];
    }
    
    self.animationImageView.animationDuration = 1.5f;
    [self.animationImageView startAnimating];
    
    //配置添加阶段提示界面构造
    [self createWifiConfigAddTipsView];
}

/*
 * “设备wifi配置、添加”阶段提示界面构造
 *
 */
- (void)createWifiConfigAddTipsView
{
    [self.view addSubview:self.addTipsView];
    
    [self.addTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.animationImageView.mas_bottom).offset(20);
        make.leading.trailing.bottom.mas_equalTo(@0);
    }];
    
    //wifi配置阶段提示label
    [self.addTipsView addSubview:self.wifiLabel];
    
    [self.wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addTipsView.mas_top).offset(30);
        make.leading.trailing.mas_equalTo(@0);
        make.height.mas_equalTo(@35);
    }];
    
    //平台注册阶段提示label
    [self.addTipsView addSubview:self.registerLabel];
    
    [self.registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wifiLabel.mas_bottom).offset(5);
        make.leading.trailing.mas_equalTo(@0);
        make.height.mas_equalTo(@35);
    }];
    
    //绑定账号阶段提示label
    [self.addTipsView addSubview:self.bindLabel];
    
    [self.bindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerLabel.mas_bottom).offset(5);
        make.leading.trailing.mas_equalTo(@0);
        make.height.mas_equalTo(@35);
    }];
    
    //倒计时显示label
    [self.addTipsView addSubview:self.timerImageView];
    
    [self.timerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@25);
        make.trailing.mas_equalTo(@-15);
        make.centerY.mas_equalTo(self.wifiLabel.mas_centerY);
    }];
    
    if ([self.timerImageView viewWithTag:0x11c])
    {
        [[self.timerImageView viewWithTag:0x11c] removeFromSuperview];
    }
    
    UILabel *operationTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    operationTime.font = [UIFont systemFontOfSize:14.0f];
    operationTime.textColor = ColorRgbValue(0xffffff);
    operationTime.backgroundColor = [UIColor clearColor];
    operationTime.textAlignment = NSTextAlignmentCenter;
    operationTime.tag = 0x11c;
    operationTime.text = @"60";//默认60秒为添加流程总时耗
    [self.timerImageView addSubview:operationTime];
    
    //wifi成功标签图
    [self.addTipsView addSubview:self.successWifiImageView];
    [self.successWifiImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@25);
        make.trailing.mas_equalTo(@-15);
        make.centerY.mas_equalTo(self.wifiLabel.mas_centerY);
    }];
    
    //注册成功标签图
    [self.addTipsView addSubview:self.successRegisterImageView];
    [self.successRegisterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@25);
        make.trailing.mas_equalTo(@-15);
        make.centerY.mas_equalTo(self.registerLabel.mas_centerY);
    }];
    
    //阶段成功标示图标,默认隐藏
    self.successRegisterImageView.hidden = YES;
    self.successWifiImageView.hidden     = YES;
}

/**
 *  显示提示界面，根据state可以标示不同的提示语
 */
- (void)showTipsView
{
    self.failedTipsView.hidden = YES;
    self.addTipsView.hidden    = NO;
    self.timerImageView.hidden = NO;
    
    switch(_enState)
    {
        case STATE_NONE:
        {
            self.successWifiImageView.hidden = YES;
            self.successRegisterImageView.hidden = YES;
            
            //字体颜色设置
            self.wifiLabel.font = [UIFont systemFontOfSize:17.0];
            self.wifiLabel.textColor = ColorRgbValue(0x333333);
            
            self.registerLabel.font = [UIFont systemFontOfSize:15.0f];
            self.registerLabel.textColor = ColorRgbValue(0x666666);
            
            self.bindLabel.font = [UIFont systemFontOfSize:15.0f];
            self.bindLabel.textColor = ColorRgbValue(0x666666);
            
            self.wifiLabel.text = @"萤小石正在努力连接Wi-Fi网络";
            self.registerLabel.text = @"注册平台服务器";
            self.bindLabel.text = @"绑定你的账号";
            
            //计算文字的长度
            CGSize labelSize = [self.wifiLabel.text sizeWithFont:self.wifiLabel.font];
            //计算padding
            CGFloat padding = (self.view.bounds.size.width - labelSize.width)/2.0f - 27.0f;
            
            [self.timerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@25);
                make.trailing.mas_equalTo(@(-padding));
                make.centerY.mas_equalTo(self.wifiLabel.mas_centerY);
            }];
        }
            break;
        case STATE_WIFI:
        {
            self.successWifiImageView.hidden = NO;
            self.successRegisterImageView.hidden = YES;
            
            self.wifiLabel.font = [UIFont systemFontOfSize:15.0];
            self.wifiLabel.textColor = ColorRgbValue(0x666666);
            
            self.registerLabel.font = [UIFont systemFontOfSize:17.0f];
            self.registerLabel.textColor = ColorRgbValue(0x333333);
            
            self.bindLabel.font = [UIFont systemFontOfSize:15.0f];
            self.bindLabel.textColor = ColorRgbValue(0x666666);
            
            self.wifiLabel.text = @"已配置好Wi-Fi网络";
            
            //计算文字的长度
            CGSize labelSize = [self.wifiLabel.text sizeWithFont:self.wifiLabel.font];
            //计算padding
            CGFloat padding = (self.view.bounds.size.width - labelSize.width)/2.0f - 27.0f;
            
            [self.successWifiImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@25);
                make.trailing.mas_equalTo(@(-padding));
                make.centerY.mas_equalTo(self.wifiLabel.mas_centerY);
            }];
            
            self.registerLabel.text = @"快了快了,正在注册平台服务器";
            self.bindLabel.text = @"绑定你的账号";
            
            //计算文字的长度
            labelSize = [self.registerLabel.text sizeWithFont:self.registerLabel.font];
            //计算padding
            padding = (self.view.bounds.size.width - labelSize.width)/2.0f - 27.0f;
            
            [self.timerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@25);
                make.trailing.mas_equalTo(@(-padding));
                make.centerY.mas_equalTo(self.registerLabel.mas_centerY);
            }];
            
            break;
        }
        case STATE_LINE:      //有线连接添加逻辑
        {
            self.successWifiImageView.hidden = YES;
            self.successRegisterImageView.hidden = YES;
            
            self.wifiLabel.hidden = YES;
            self.registerLabel.hidden = YES;
            self.timerImageView.hidden = NO;
            
            self.bindLabel.font = [UIFont systemFontOfSize:17.0];
            self.bindLabel.textColor = ColorRgbValue(0x333333);
            self.bindLabel.text = @"绑到你的账号下就大功告成了哦";
            
            //计算文字的长度
            CGSize labelSize = [self.bindLabel.text sizeWithFont:self.bindLabel.font];
            //计算padding
            CGFloat padding = (self.view.bounds.size.width - labelSize.width)/2.0f - 27.0f;
            
            [self.timerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@25);
                make.trailing.mas_equalTo(@(-padding));
                make.centerY.mas_equalTo(self.bindLabel.mas_centerY);
            }];
            
            break;
        }
        case STATE_PLAT:
        {
            self.successWifiImageView.hidden = NO;
            self.successRegisterImageView.hidden = NO;
            
            self.wifiLabel.font = [UIFont systemFontOfSize:15.0];
            self.wifiLabel.textColor = ColorRgbValue(0x666666);
            
            self.registerLabel.font = [UIFont systemFontOfSize:15.0f];
            self.registerLabel.textColor = ColorRgbValue(0x666666);
            
            self.bindLabel.font = [UIFont systemFontOfSize:17.0f];
            self.bindLabel.textColor = ColorRgbValue(0x333333);
            
            self.wifiLabel.text = @"已配置好Wi-Fi网络";
            self.registerLabel.text = @"已注册到萤石平台";
            //计算文字的长度
            CGSize labelSize = [self.registerLabel.text sizeWithFont:self.registerLabel.font];
            //计算padding
            CGFloat padding = (self.view.bounds.size.width - labelSize.width)/2.0f - 27.0f;
            
            [self.successWifiImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@25);
                make.trailing.mas_equalTo(@(-padding));
                make.centerY.mas_equalTo(self.wifiLabel.mas_centerY);
            }];
            
            [self.successRegisterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@25);
                make.trailing.mas_equalTo(@(-padding));
                make.centerY.mas_equalTo(self.registerLabel.mas_centerY);
            }];
            
            self.bindLabel.text = @"绑到你的账号下就大功告成了哦";
            
            //计算文字的长度
            labelSize = [self.bindLabel.text sizeWithFont:self.bindLabel.font];
            //计算padding
            padding = (self.view.bounds.size.width - labelSize.width)/2.0f - 27.0f;
            
            [self.timerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@25);
                make.trailing.mas_equalTo(@(-padding));
                make.centerY.mas_equalTo(self.bindLabel.mas_centerY);
            }];
            
            break;
        }
        case STATE_SUCC:
        {
            //隐藏阶段提示界面，展示成功界面
            self.addTipsView.hidden = YES;
            
            [self.animationImageView stopAnimating];
            self.animationImageView.animationImages = nil;
            //调整图片高度
            
            self.animationImageView.image = [UIImage imageNamed:@"addDevice_success"];//成功标示图片
            
            [self.animationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@90);
                make.leading.trailing.mas_equalTo(@0);
                make.height.mas_equalTo(@(185 * [UIScreen mainScreen].bounds.size.width/320.0f));
            }];
            
            [self.view addSubview:self.completionLabel];
            
            [self.completionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.animationImageView.mas_bottom).offset(10);
                make.leading.trailing.mas_equalTo(@0);
                make.height.mas_equalTo(@20);
            }];
            
            [self.view addSubview:self.completionButton];
            
            [self.completionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.completionLabel.mas_bottom).offset(15);
                make.height.mas_equalTo(50);
                make.left.equalTo(self.view).offset(20);
                make.right.equalTo(self.view).offset(-20);
            }];
            
            break;
        }
        default:
            break;
    }
}

/**
 *  显示失败界面，根据state可以标示不同的失败类型
 */
- (void)showFailedView
{
    [EZOPENSDK stopConfigWifi];
    
    //失败-移除阶段提示视图
    self.addTipsView.hidden = YES;
    
    //失败-配置特效动画停止
    [self.animationImageView stopAnimating];
    
    [self.view addSubview:self.failedTipsView];
    
    [self.failedTipsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.failedTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.animationImageView.mas_bottom).offset(20);
        make.leading.trailing.bottom.mas_equalTo(@0);
    }];
    
    UILabel *failedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    failedLabel.numberOfLines = 0;
    failedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    failedLabel.font = [UIFont systemFontOfSize:15.0f];
    failedLabel.textColor = ColorRgbValue(0x666666);
    failedLabel.textAlignment = NSTextAlignmentCenter;
    failedLabel.backgroundColor = [UIColor clearColor];
    failedLabel.tag = 0x22a;
    [self.failedTipsView addSubview:failedLabel];
    
    [failedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.leading.mas_equalTo(@15);
        make.trailing.mas_equalTo(@-15);
        make.height.mas_equalTo(@45);
    }];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retryButton setTitle:@"重试" forState:UIControlStateNormal];
    retryButton.backgroundColor = ThemeColor;
    [retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(retryButton, 25, 0, ThemeColor);
    [retryButton addTarget:self action:@selector(retryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    retryButton.tag = 0x22c;
    [self.failedTipsView addSubview:retryButton];
    
    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(failedLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *failedLab = (UILabel *)[self.failedTipsView viewWithTag:0x22a];
    
    switch (_enState)
    {
        case STATE_NONE:
        {
            failedLab.text = @"配置Wi-Fi失败，请重试或返回检查Wi-Fi密码是否输入正确";
            
            self.animationImageView.image = [UIImage imageNamed:@"failure_wifi"]; //wifi连接失败
        }
            break;
        case STATE_WIFI:
        case STATE_LINE:
        {
            failedLab.text = @"Wi-Fi配置成功,注册平台失败,请检查设备网络后重试";
            
            self.animationImageView.image = [UIImage imageNamed:@"failure_server"];//设备注册平台失败
        }
            break;
        case STATE_PLAT:
        {
            failedLab.text = @"Wi-Fi配置成功,绑定账号失败,请重试";
            
            self.animationImageView.image = [UIImage imageNamed:@"failure_account"];//设备绑定失败
        }
            break;
        default:
            break;
    }
    
    self.failedTipsView.hidden = NO;
}

- (void)handleTheError:(NSError *)error
{
    
    if (!error)
    {
        if ([_countTimer isValid])
        {
            [_countTimer invalidate];
            _countTimer = nil;
        }
        _enState = STATE_SUCC;
        [self showTipsView];
        return;
    }
    
    if (error.code == 120010)
    {
        UIAlertView *retryAlertView = [[UIAlertView alloc] initWithTitle:@"验证码错误"
                                                                 message:nil delegate:self
                                                       cancelButtonTitle: @"取消"
                                                       otherButtonTitles: @"重试", nil];
        retryAlertView.tag = 0xbb;
        [retryAlertView show];
    }
    else if (error.code == 120020)
    {
        [self showHUDWithText:@"您已添加过此设备"];
    }
    else if (error.code == 120022)
    {
        [self showHUDWithText:@"此设备已被别人添加"];
    }
    else
    {
        [self showHUDWithText:@"添加失败"];
    }
}

#pragma mark - Action Methods

- (void)completionButtonClicked:(id)sender
{
    [self addAction];
}

- (void)retryButtonClicked:(id)sender
{
    [self wifiConfigStart];
}


#pragma mark - Get & Set Methods

- (UIImageView *)animationImageView
{
    if (!_animationImageView)
    {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _animationImageView;
}

- (UIView *)addTipsView
{
    if (!_addTipsView)
    {
        _addTipsView = [[UIView alloc] initWithFrame:CGRectZero];
        _addTipsView.backgroundColor = [UIColor clearColor];
    }
    return _addTipsView;
}

- (UIImageView *)timerImageView
{
    if (!_timerImageView)
    {
        
        UIImage *image = [self dd_createImageWithCGSize:CGSizeMake(25.0, 25.0) color:ColorRgbValue(0x1b9ee2)];
        _timerImageView = [[UIImageView alloc] initWithImage:image];
        _timerImageView.clipsToBounds = YES;
        _timerImageView.layer.cornerRadius = 25/2.0;
    }
    return _timerImageView;
}

- (UIImageView *)successRegisterImageView{
    if (!_successRegisterImageView)
    {
        _successRegisterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_success_icon"]];
    }
    return _successRegisterImageView;
}

- (UIImageView *)successWifiImageView
{
    if (!_successWifiImageView)
    {
        _successWifiImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_success_icon"]];
    }
    return _successWifiImageView;
}

- (UILabel *)wifiLabel
{
    if (!_wifiLabel)
    {
        _wifiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _wifiLabel.font = [UIFont systemFontOfSize:15.0f];
        _wifiLabel.textColor = ColorRgbValue(0x333333);
        _wifiLabel.backgroundColor = [UIColor clearColor];
        _wifiLabel.textAlignment = NSTextAlignmentCenter;
        _wifiLabel.text = @"正在连接Wi-Fi网络";
    }
    return _wifiLabel;
}

- (UILabel *)registerLabel
{
    if (!_registerLabel)
    {
        _registerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _registerLabel.font = [UIFont systemFontOfSize:15.0f];
        _registerLabel.textColor = ColorRgbValue(0x333333);
        _registerLabel.backgroundColor = [UIColor clearColor];
        _registerLabel.textAlignment = NSTextAlignmentCenter;
        _registerLabel.text = @"注册平台服务器";
    }
    return _registerLabel;
}

- (UILabel *)bindLabel
{
    if (!_bindLabel)
    {
        _bindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bindLabel.font = [UIFont systemFontOfSize:15.0f];
        _bindLabel.textColor = ColorRgbValue(0x333333);
        _bindLabel.backgroundColor = [UIColor clearColor];
        _bindLabel.textAlignment = NSTextAlignmentCenter;
        _bindLabel.text =  @"绑定你的账号";
    }
    return _bindLabel;
}

- (UIView *)failedTipsView
{
    if(!_failedTipsView)
    {
        _failedTipsView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _failedTipsView;
}

- (UILabel *)completionLabel
{
    if (!_completionLabel)
    {
        _completionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _completionLabel.text =  @"添加成功";
        _completionLabel.textAlignment = NSTextAlignmentCenter;
        _completionLabel.font = [UIFont systemFontOfSize:15.0f];
        _completionLabel.backgroundColor = [UIColor clearColor];
    }
    return _completionLabel;
}

- (UIButton *)completionButton
{
    if (!_completionButton)
    {
        _completionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _completionButton.backgroundColor = ThemeColor;
        [_completionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completionButton setTitle:@"完成" forState:UIControlStateNormal];
        LRViewBorderRadius(_completionButton, 25, 0, ThemeColor);
        [_completionButton addTarget:self action:@selector(completionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completionButton;
}

- (UIImage *)dd_createImageWithCGSize:(CGSize)size color:(UIColor *)color{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addAction{
    NSDictionary *params = @{@"deviceSerialNo":self.deviceSerialNo,@"deviceName":self.deviceSerialNo,@"deviceType":@(2),@"devicePassword":@"",@"mobile":[KRUserInfo sharedKRUserInfo].mobile,@"elderId":[KRUserInfo sharedKRUserInfo].elderId,@"validateCode":self.deviceVerifyCode};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/device/addDevice.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_DEVICE_SUCCESS object:nil];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[NSClassFromString(@"LookViewController") class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        }
    }];
}

@end

