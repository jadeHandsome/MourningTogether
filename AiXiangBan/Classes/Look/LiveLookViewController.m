//
//  LiveLookViewController.m
//  孝相伴
//
//  Created by MAC on 17/10/10.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LiveLookViewController.h"
#import "AppDelegate.h"
#import "EZPlayer.h"
#import "HIKLoadView.h"
#import "AFNetworking.h"
@interface LiveLookViewController ()<EZPlayerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIView *qualityView;
@property (weak, nonatomic) IBOutlet UIButton *qualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceControlBtn;
@property (weak, nonatomic) IBOutlet UIButton *playerControlBtn;
@property (nonatomic, assign) BOOL isFull;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *vioceView;
@property (weak, nonatomic) IBOutlet UIView *bottomVoiceView;
@property (weak, nonatomic) IBOutlet UIView *PTZView;
@property (weak, nonatomic) IBOutlet UIView *PTZCenterView;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat naviHeight;
@property (weak, nonatomic) IBOutlet UIButton *PTZBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *shotBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenshotBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *PTZImage;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;
@property (weak, nonatomic) IBOutlet UIImageView *shotImage;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImage;
@property (weak, nonatomic) IBOutlet UIImageView *voideImage;
@property (weak, nonatomic) IBOutlet UIImageView *historyImage;
@property (weak, nonatomic) IBOutlet UILabel *PTZText;
@property (weak, nonatomic) IBOutlet UILabel *voiceText;
@property (weak, nonatomic) IBOutlet UILabel *shotText;
@property (weak, nonatomic) IBOutlet UILabel *screenshotText;
@property (weak, nonatomic) IBOutlet UILabel *videoText;
@property (nonatomic) BOOL isStartingTalk;
@property (nonatomic, strong) EZCameraInfo *cameraInfo;
@property (nonatomic, strong) EZPlayer *player;
@property (nonatomic, strong) EZPlayer *talkPlayer;
@property (nonatomic) BOOL isOpenSound;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isPressed;
@property (nonatomic, strong) NSMutableData *fileData;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) HIKLoadView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIView *PTTop;
@property (weak, nonatomic) IBOutlet UIView *PTRight;
@property (weak, nonatomic) IBOutlet UIView *PTBottom;
@property (weak, nonatomic) IBOutlet UIView *PTLeft;
@property (weak, nonatomic) IBOutlet UILabel *talkdisplay;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) int camareEnable;
@property (weak, nonatomic) IBOutlet UIButton *voicePressBtn;
@property (nonatomic, strong) NSString *cheakCode;
@end



@implementation LiveLookViewController

- (void)dealloc
{
    NSLog(@"%@ dealloc", self.class);
    [EZOPENSDK releasePlayer:_player];
    [EZOPENSDK releasePlayer:_talkPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"看看";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    [self config];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isFull = YES;
    [self addCornerRadius:self.functionView];
    [self addCornerRadius:self.bottomVoiceView];
    [self addCornerRadius:self.PTZView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isFull = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(self.isRecording)
    {
        [_player stopLocalRecord];
        [self.fileData writeToFile:_filePath atomically:YES];
        [self saveRecordToPhotosAlbum:_filePath];
    }
    
    [_player stopRealPlay];
    [_talkPlayer stopVoiceTalk];
}


- (void)setUp{
    self.screenHeight = SIZEHEIGHT;
    self.naviHeight = navHight;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"云医时代-53"] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
////    self.navigationItem.rightBarButtonItem.imageInsets = UIEdgeInsetsMake(5, 10, -5,-10);
    self.topConstraint.constant = navHight + 10;
    self.bottomConstraint.constant = SIZEHEIGHT - navHight - 10 - 220;
    LRViewBorderRadius(self.vioceView, 11.5, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.recordView, 11.5, 0, [UIColor clearColor]);
    [self addLongPress:self.PTTop];
    [self addLongPress:self.PTLeft];
    [self addLongPress:self.PTRight];
    [self addLongPress:self.PTBottom];
}

- (void)addLongPress:(UIView *)view{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(PTControlling:)];
    longPress.minimumPressDuration = 0.1;
    [view addGestureRecognizer:longPress];
}

- (void)config{
    self.camareEnable = 1;
    if (self.deviceInfo.status == 2) {
        [self showHUDWithText:@"设备不在线"];
    }
    self.isStartingTalk = NO;
    [self disenable];
    self.cameraInfo = self.deviceInfo.cameraInfo[0];
    self.player = [EZOPENSDK createPlayerWithDeviceSerial:_cameraInfo.deviceSerial cameraNo:_cameraInfo.cameraNo];
    self.talkPlayer = [EZOPENSDK createPlayerWithDeviceSerial:_cameraInfo.deviceSerial cameraNo:_cameraInfo.cameraNo];

    if (_cameraInfo.videoLevel == 2)
    {
        [self.qualityBtn setTitle:@"高清" forState:UIControlStateNormal];
    }
    else if (_cameraInfo.videoLevel == 1)
    {
        [self.qualityBtn setTitle:@"均衡" forState:UIControlStateNormal];
    }
    else
    {
        [self.qualityBtn setTitle:@"流畅" forState:UIControlStateNormal];
    }
    
    if (self.deviceInfo.isEncrypt) {
        NSString *verifyCode = [self getFromDefaultsWithKey:@"VerifyCodeDic"][self.deviceInfo.deviceSerial];
        if (verifyCode) {
            [_player setPlayVerifyCode:verifyCode];
            [_talkPlayer setPlayVerifyCode:verifyCode];
        }
    }
    
    if(!_loadingView)
        _loadingView = [[HIKLoadView alloc] initWithHIKLoadViewStyle:HIKLoadViewStyleSqureClockWise];
    [self.view insertSubview:_loadingView aboveSubview:self.playerView];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@14);
        make.centerX.mas_equalTo(self.playerView.mas_centerX);
        make.centerY.mas_equalTo(self.playerView.mas_centerY);
    }];
    [self.loadingView startSquareClcokwiseAnimation];
    

    
    _player.delegate = self;
    _talkPlayer.delegate = self;
    _isOpenSound = YES;
    
    [_player setPlayerView:_playerView];
    [_player startRealPlay];
}

- (void)rightItemAction{
    
}


- (void)addCornerRadius:(UIView *)view{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (IBAction)startOrStop:(UIButton *)sender {
    if(self.deviceInfo.status == 2){
        [self showHUDWithText:@"设备不在线"];
    }
    else{
        if(_isPlaying)
        {
            [_player stopRealPlay];
            [self.playerControlBtn setImage:IMAGE_NAMED(@"云医时代2-7") forState:UIControlStateNormal];
            [self disenable];
            self.playerControlBtn.enabled = YES;
        }
        else
        {
            [_player startRealPlay];
            [self.playerControlBtn setImage:IMAGE_NAMED(@"云医时代-66") forState:UIControlStateNormal];
            
            [self.loadingView startSquareClcokwiseAnimation];
        }
        _isPlaying = !_isPlaying;
    }
}
- (IBAction)voiceAction:(UIButton *)sender {
    if (self.deviceInfo.status == 2) {
        [self showHUDWithText:@"设备不在线"];
    }
    else{
        if(_isOpenSound){
            [_player closeSound];
            [self.voiceControlBtn setImage:IMAGE_NAMED(@"云医时代-67") forState:UIControlStateNormal];  ;
        }
        else
        {
            [_player openSound];
            [self.voiceControlBtn setImage:IMAGE_NAMED(@"云医时代2-8") forState:UIControlStateNormal];
        }
        _isOpenSound = !_isOpenSound;
    }
}
- (IBAction)enterFullScreen:(UIButton *)sender {
    if(self.isFull){
        [self setDecivePortrait];
    }
    else{
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}
- (IBAction)changeQuality:(UIButton *)sender {
    if(!self.qualityView.hidden)
    {
        self.qualityView.hidden = YES;
    }
    else
    {
        self.qualityView.hidden = NO;
        //停留5s以后隐藏视频质量View.
        [self performSelector:@selector(hideQualityView) withObject:nil afterDelay:2.0f];
    }
}

- (void)hideQualityView
{
    self.qualityView.hidden = YES;
}

- (IBAction)quality:(UIButton *)sender {
    BOOL result = NO;
    EZVideoLevelType type = EZVideoLevelLow;
    switch (sender.tag) {
        case 100:
            //流畅
            type = EZVideoLevelLow;
            break;
        case 101:
            //普通
            type = EZVideoLevelMiddle;
            break;
        case 102:
            //高清
            type = EZVideoLevelHigh;
            break;
        default:
            break;
    }
    [EZOPENSDK setVideoLevel:_cameraInfo.deviceSerial
                    cameraNo:_cameraInfo.cameraNo
                  videoLevel:type
                  completion:^(NSError *error) {
                      if (error)
                      {
                          return;
                      }
                      [_player stopRealPlay];
                      if (sender.tag == 102)
                      {
                          [self.qualityBtn setTitle:@"高清" forState:UIControlStateNormal];
                      }
                      else if (sender.tag == 101)
                      {
                          [self.qualityBtn setTitle:@"均衡" forState:UIControlStateNormal];
                      }
                      else
                      {
                          [self.qualityBtn setTitle:@"流畅" forState:UIControlStateNormal];
                      }
                      self.qualityView.hidden = YES;
                      if (result)
                      {
                          [self.loadingView startSquareClcokwiseAnimation];
                      }
                      [_player startRealPlay];
                  }];
    
}

- (IBAction)functionViewAction:(UIButton *)sender {
    if (self.deviceInfo.status == 2) {
        [self showHUDWithText:@"设备不在线"];
    }
    else{
        NSLog(@"点击了%ld",sender.tag);
        switch (sender.tag) {
            case 200:
                //云台
                if (self.deviceInfo.isSupportPTZ) {
                    self.PTZView.hidden = NO;
                }
                else{
                    [self showHUDWithText:@"该设备不支持平台控制"];
                }
                break;
            case 201:
                //语音
            {
                if (self.deviceInfo.isSupportTalk) {
                    if (self.deviceInfo.isSupportTalk != 1 && self.deviceInfo.isSupportTalk != 3)
                    {
                        self.voicePressBtn.enabled = NO;
                        return;
                    }
                    if (self.deviceInfo.isSupportTalk == 3) {
                        self.voicePressBtn.enabled = YES;
                        self.talkdisplay.text = @"轻点后说话";
                    }
                    self.bottomVoiceView.hidden = NO;
                    self.isStartingTalk = YES;
                    [_talkPlayer startVoiceTalk];
                }
                else{
                    [self showHUDWithText:@"该设备不支持对讲"];
                }
            }
                break;
            case 202:
                //镜头
                [self setCameraStatus];
                break;
            case 203:
                //截图
            {
                UIImage *image = [_player capturePicture:100];
                [self saveImageToPhotosAlbum:image];
            }
                break;
            case 204:
                //录像
                [self videoRecord];
                break;
            case 205:
                //历史影像
                break;
                
            default:
                break;
        }
    }
}

- (void)setCameraStatus{
    int enable = self.camareEnable == 1 ? 0 : 1;
    NSDictionary *params = @{@"accessToken":self.accessToken,@"deviceSerial":self.deviceInfo.deviceSerial,@"enable":@(enable),@"channelNo":@(self.cameraInfo.cameraNo)};
    __block MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    UIView *cusTome = [[UIView alloc]init];
    cusTome.backgroundColor = [UIColor blackColor];
    HUD.customView = cusTome;
    HUD.removeFromSuperViewOnHide = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"https://open.ys7.com/api/lapp/device/scene/switch/set" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        [HUD hideAnimated:YES];
        NSDictionary *response = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        } else {
            response = responseObject;
        }
        if ([response[@"code"] isEqualToString:@"200"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"摄像头%@成功",enable == 1?@"开启":@"关闭"] toView:self.view];
            self.camareEnable = !self.camareEnable;
        }
        else{
            [MBProgressHUD showError:@"操作失败" toView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络异常" toView:self.view];
    }];
}


- (IBAction)closeVoice:(UIButton *)sender {
    [_talkPlayer stopVoiceTalk];
    self.vioceView.hidden = YES;
    self.bottomVoiceView.hidden = YES;
}

- (IBAction)closePTZ:(UIButton *)sender {
    self.PTZView.hidden = YES;
}



- (BOOL)shouldAutorotate {
    return YES;
}

- (void)setDecivePortrait{
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    self.isFull = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.topConstraint.constant = self.naviHeight + 10;
    self.leftConstraint.constant = 10;
    self.rightConstraint.constant = 10;
    self.bottomConstraint.constant = self.screenHeight - self.naviHeight - 10 - 220;;
    self.functionView.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.isFull = YES;
        self.navigationController.navigationBar.hidden = YES;
        self.topConstraint.constant = 10;
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
        self.bottomConstraint.constant = 45;
        self.functionView.hidden = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)saveRecordToPhotosAlbum:(NSString *)path
{
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)saveImageToPhotosAlbum:(UIImage *)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"已保存至手机相册";
    }
    else
    {
        message = [error description];
    }
    [self showHUDWithText:message];
}

#pragma mark - PlayerDelegate Methods

- (void)player:(EZPlayer *)player didReceivedDataLength:(NSInteger)dataLength
{
    CGFloat value = dataLength/1024.0;
    NSString *fromatStr = [NSString stringWithFormat:@"%.1f KB/s",value];
    if (value > 1024)
    {
        value = value/1024;
        fromatStr = [NSString stringWithFormat:@"%.1f MB/s",value];
    }
    self.speedLabel.text = fromatStr;
}

- (void)player:(EZPlayer *)player didPlayFailed:(NSError *)error
{
    NSLog(@"player: %@, didPlayFailed: %@", player, error);
    //如果是需要验证码或者是验证码错误
    if (error.code == EZ_SDK_NEED_VALIDATECODE) {
        [self showSetPassword];
        return;
    } else if (error.code == EZ_SDK_VALIDATECODE_NOT_MATCH) {
        [self showRetry];
        return;
    } else if (error.code == EZ_SDK_NOT_SUPPORT_TALK) {
        [self showHUDWithText:[NSString stringWithFormat:@"%d", (int)error.code]];
        return;
    }else if (error.code == 34) {//34错误特殊操作
        [_player stopRealPlay];
        [_player startRealPlay];
        return;
    }
    self.bottomVoiceView.hidden = YES;
    [self showHUDWithText:[NSString stringWithFormat:@"播放失败%d", (int)error.code]];
    [self.loadingView stopSquareClockwiseAnimation];
}

- (void)player:(EZPlayer *)player didReceivedMessage:(NSInteger)messageCode
{
    if (messageCode == PLAYER_REALPLAY_START)
    {
        if (self.cheakCode) {
            NSMutableDictionary *VerifyCodeDic = [NSMutableDictionary dictionaryWithDictionary:[self getFromDefaultsWithKey:@"VerifyCodeDic"]];
            if (![[VerifyCodeDic allKeys] containsObject:self.deviceInfo.deviceSerial]) {
                VerifyCodeDic[self.deviceInfo.deviceSerial] = self.cheakCode;
                [self saveToUserDefaultsWithKey:@"VerifyCodeDic" Value:VerifyCodeDic];
            }
        }
        [self able];
        [self.playerControlBtn setImage:IMAGE_NAMED(@"云医时代-66") forState:UIControlStateNormal];
        [self.loadingView stopSquareClockwiseAnimation];
        _isPlaying = YES;
        if (!_isOpenSound)
        {
            [_player closeSound];
        }
    }
    else if(messageCode == PLAYER_VOICE_TALK_START)
    {
        [_player closeSound];
        self.isStartingTalk = NO;
        self.bottomVoiceView.hidden = NO;
        self.vioceView.hidden = NO;
        [self.playerView bringSubviewToFront:self.vioceView];
    }
    else if (messageCode == PLAYER_VOICE_TALK_END)
    {
        //对讲结束开启声音
        [_player openSound];
    }
}





#pragma mark - ValidateCode Methods

- (void)showSetPassword
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入视频图片加密密码"
                                                        message:@"您的视频已加密，请输入密码进行查看，初始密码为机身标签上的验证码，如果没有验证码，请输入ABCDEF（密码区分大小写)"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
}

- (void)showRetry
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"设备密码错误"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:NSLocalizedString(@"重试", nil), nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle == UIAlertViewStyleSecureTextInput)
    {
        if (buttonIndex == 1)
        {
            NSString *checkCode = [alertView textFieldAtIndex:0].text;
            self.cheakCode = checkCode;
            if (!self.isStartingTalk)
            {
                [self.player setPlayVerifyCode:checkCode];
                [self.player startRealPlay];
            }
            else
            {
                [self.talkPlayer setPlayVerifyCode:checkCode];
                [self.talkPlayer startVoiceTalk];
            }
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            [self showSetPassword];
            return;
        }
    }
}
- (IBAction)PTControl:(UIButton *)sender {
    EZPTZCommand command;
    if (sender == self.PTTop) {
        command = EZPTZCommandUp;
    }
    else if (sender == self.PTRight){
        command = EZPTZCommandRight;
    }
    else if (sender == self.PTBottom){
        command = EZPTZCommandDown;
    }
    else{
        command = EZPTZCommandLeft;
    }
    EZCameraInfo *cameraInfo = [self.deviceInfo.cameraInfo firstObject];
    [EZOPENSDK controlPTZ:cameraInfo.deviceSerial
                 cameraNo:cameraInfo.cameraNo
                  command:command
                   action:EZPTZActionStart
                    speed:2
                   result:^(NSError *error) {
                       if (error) {
                           [self showHUDWithText:[NSString stringWithFormat:@"控制失败%d", (int)error.code]];
                       }
                   }];
    
}

- (void)PTControlling:(UILongPressGestureRecognizer *)sender{
    EZPTZCommand command;
    switch (sender.view.tag) {
        case 30:
            command = EZPTZCommandUp;
            break;
        case 31:
            command = EZPTZCommandRight;
            break;
        case 32:
            command = EZPTZCommandDown;
            break;
        case 33:
            command = EZPTZCommandLeft;
            break;
        default:
            break;
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        EZCameraInfo *cameraInfo = [self.deviceInfo.cameraInfo firstObject];
        [EZOPENSDK controlPTZ:cameraInfo.deviceSerial
                     cameraNo:cameraInfo.cameraNo
                      command:command
                       action:EZPTZActionStart
                        speed:2
                       result:^(NSError *error) {
                           if (error) {
                               if (error.code == 160002) {
                                [self showHUDWithText:@"已经到最顶部"];
                               }
                               if (error.code == 160003) {
                                   [self showHUDWithText:@"已经到最底部"];
                               }
                               if (error.code == 160004) {
                                   [self showHUDWithText:@"已经到最左部"];
                               }
                               if (error.code == 160005) {
                                   [self showHUDWithText:@"已经到最右部"];
                               }
                           }
                       }];
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
        EZCameraInfo *cameraInfo = [self.deviceInfo.cameraInfo firstObject];
        [EZOPENSDK controlPTZ:cameraInfo.deviceSerial
                     cameraNo:cameraInfo.cameraNo
                      command:command
                       action:EZPTZActionStop
                        speed:2
                       result:^(NSError *error) {
                           if (error) {
                               [self showHUDWithText:[NSString stringWithFormat:@"控制失败%d", (int)error.code]];
                           }
                       }];
    }
}

//录像
- (void)videoRecord{
    //结束本地录像
    if(self.isRecording)
    {
        self.isRecording = NO;
        self.recordView.hidden = YES;
        [_player stopLocalRecord];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [_fileData writeToFile:_filePath atomically:YES];
            [self saveRecordToPhotosAlbum:_filePath];
            _filePath = nil;
        });
    }
    else
    {
        self.isRecording = YES;
        self.recordView.hidden = NO;
        [self.playerView bringSubviewToFront:self.recordView];
        //开始本地录像
        NSString *path = @"/OpenSDK/EzvizLocalRecord";
        NSArray * docdirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * docdir = [docdirs objectAtIndex:0];

        NSString * configFilePath = [docdir stringByAppendingPathComponent:path];
        if(![[NSFileManager defaultManager] fileExistsAtPath:configFilePath]){
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:configFilePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyyMMddHHmmssSSS";
        _filePath = [NSString stringWithFormat:@"%@/%@.mov",configFilePath,[dateformatter stringFromDate:[NSDate date]]];
        _fileData = [NSMutableData new];

        __weak __typeof(self) weakSelf = self;
        [_player startLocalRecord:^(NSData *data) {
            if (!data || !weakSelf.fileData) {
                return;
            }
            [weakSelf.fileData appendData:data];
        }];
    }

}
- (IBAction)talkPressed:(UIButton *)sender {
    if (!_isPressed)
    {
        self.talkdisplay.text = @"轻点切换为听";
        [self.talkPlayer audioTalkPressed:YES];
    }
    else
    {
        self.talkdisplay.text = @"轻点切换为讲";
        [self.talkPlayer audioTalkPressed:NO];
    }
    _isPressed = !_isPressed;
}

- (void)disenable{
    self.PTZImage.image = IMAGE_NAMED(@"云医时代2-1");
    self.voiceImage.image = IMAGE_NAMED(@"云医时代2-3");
    self.shotImage.image = IMAGE_NAMED(@"云医时代2-2");
    self.screenshotImage.image = IMAGE_NAMED(@"云医时代2-4");
    self.voideImage.image = IMAGE_NAMED(@"云医时代2-5");
    self.PTZText.textColor = ColorRgbValue(0x989898);
    self.voiceText.textColor = ColorRgbValue(0x989898);
    self.shotText.textColor = ColorRgbValue(0x989898);
    self.screenshotText.textColor = ColorRgbValue(0x989898);
    self.videoText.textColor = ColorRgbValue(0x989898);
    self.PTZBtn.enabled = NO;
    self.voiceBtn.enabled = NO;
    self.shotBtn.enabled = NO;
    self.screenshotBtn.enabled = NO;
    self.videoBtn.enabled = NO;
    self.voiceControlBtn.enabled = NO;
    self.playerControlBtn.enabled = NO;
    self.qualityBtn.enabled = NO;
}

- (void)able{
    self.shotBtn.enabled = YES;
    self.screenshotBtn.enabled = YES;
    self.videoBtn.enabled = YES;
    self.voiceControlBtn.enabled = YES;
    self.playerControlBtn.enabled = YES;
    self.qualityBtn.enabled = YES;
    self.PTZBtn.enabled = YES;
    self.voiceBtn.enabled = YES;
    self.PTZImage.image = self.deviceInfo.isSupportPTZ ? IMAGE_NAMED(@"云医时代-56") : IMAGE_NAMED(@"云医时代2-1");
    self.voiceImage.image = self.deviceInfo.isSupportTalk ? IMAGE_NAMED(@"云医时代-57") : IMAGE_NAMED(@"云医时代2-3");
    self.shotImage.image = IMAGE_NAMED(@"云医时代-55");
    self.screenshotImage.image = IMAGE_NAMED(@"云医时代-58");
    self.voideImage.image = IMAGE_NAMED(@"云医时代2-18");
    self.PTZText.textColor = self.deviceInfo.isSupportPTZ ? ColorRgbValue(0x35D79C) : ColorRgbValue(0x989898);
    self.voiceText.textColor = self.deviceInfo.isSupportTalk ? ColorRgbValue(0xE2D423) : ColorRgbValue(0x989898);;
    self.shotText.textColor = ColorRgbValue(0x5CB5EE);
    self.screenshotText.textColor = ColorRgbValue(0xF06589);
    self.videoText.textColor = ColorRgbValue(0x97A2CC);
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
