//
//  AddByQRCodeViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddByQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EZQRView.h"
#import "AddbyViewController.h"

@interface AddByQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVAuthorizationStatus authStatus;
}

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (weak, nonatomic) IBOutlet EZQRView *QRView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIButton *buyHandBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation AddByQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描";
    [self setUp];
    
    
    authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized)
    {
        [self qrSetup];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     if (granted)
                                     {
                                         [self qrSetup];
                                         [_session startRunning];
                                     }
                                 }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的`设置-隐私-相机`中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    self.QRView.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (authStatus == AVAuthorizationStatusDenied ||
        authStatus == AVAuthorizationStatusRestricted)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        return;
    }
    [self showLoadingHUDWithText:@""];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (authStatus == AVAuthorizationStatusDenied ||
        authStatus == AVAuthorizationStatusRestricted) {
        return;
    }
    [_session startRunning];
    
    _preview.frame = CGRectMake(0, navHight, SIZEWIDTH, SIZEHEIGHT - navHight);
    
    //修正扫描区域
    CGFloat screenHeight = SIZEHEIGHT - navHight;
    CGFloat screenWidth = SIZEWIDTH;
    CGRect cropRect = CGRectMake(25, (SIZEHEIGHT - SIZEWIDTH + 50) / 2 - navHight - 30, SIZEWIDTH - 50,SIZEWIDTH - 50);
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y/screenHeight, cropRect.origin.x/screenWidth, cropRect.size.height/screenHeight, cropRect.size.width/screenWidth)];
    [self addLineAnimation];
    [self hideHUD];
    self.QRView.hidden = NO;
}



- (void)setUp{
    self.topConstraint.constant = navHight;
    self.LineConstraint.constant = (SIZEHEIGHT - SIZEWIDTH + 50) / 2 - navHight - 30;
    LRViewBorderRadius(self.buyHandBtn, 10, 0, [UIColor clearColor]);
}

- (void)qrSetup
{
    if(!_device)
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    if(!_input)
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    if(!_output)
        _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    if(!_session)
        _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    AVCaptureConnection *outputConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
    outputConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Preview
    if(!_preview)
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    _preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate Methods
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] > 0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self checkQRCode:stringValue];
}

- (void)checkQRCode:(NSString *)strQRcode
{
    //萤石
    if (self.deviceType == 2) {
        NSArray *arrString = [strQRcode componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if(arrString.count >= 2)
        {
            AddbyViewController *addVC = [AddbyViewController new];
            addVC.deviceSerialNo = arrString[1];
            addVC.deviceVerifyCode = arrString[2];
            addVC.deviceType = self.deviceType;
            [self.navigationController pushViewController:addVC animated:YES];
        } else {
            [self showHUDWithText:@"不支持的二维码类型，转用手动输入"];
            [self performSelector:@selector(goByHand) withObject:nil afterDelay:1];
        }
    }
    else{
        AddbyViewController *addVC = [AddbyViewController new];
        addVC.deviceSerialNo = strQRcode;
        addVC.deviceType = self.deviceType;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

//动画
- (void)addLineAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @(0);
    animation.toValue = @(SIZEWIDTH - 50);
    animation.duration = 3.0f;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    [_lineImageView.layer addAnimation:animation forKey:nil];
}
- (IBAction)AddByHand:(UIButton *)sender {
    [self goByHand];
}

- (void)goByHand{
    AddbyViewController *byHandVC = [AddbyViewController new];
    byHandVC.deviceType = 2;
    [self.navigationController pushViewController:byHandVC animated:YES];
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
