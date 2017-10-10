//
//  LiveLookViewController.m
//  孝相伴
//
//  Created by MAC on 17/10/10.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LiveLookViewController.h"
@interface LiveLookViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIView *qualityView;
@property (weak, nonatomic) IBOutlet UIButton *qualityBtn;
@property (nonatomic, assign) BOOL isFull;
@property (weak, nonatomic) IBOutlet UIView *vioceView;
@property (weak, nonatomic) IBOutlet UIView *bottomVoiceView;
@property (weak, nonatomic) IBOutlet UIView *PTZView;
@property (weak, nonatomic) IBOutlet UIButton *PTZBtn1;
@property (weak, nonatomic) IBOutlet UIView *PTZCenterView;
@property (weak, nonatomic) IBOutlet UIView *PTZCenterItem;
@property (weak, nonatomic) IBOutlet UIImageView *PTZImageView;
@property (weak, nonatomic) IBOutlet UILabel *PTZLabel;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat naviHeight;
@end



@implementation LiveLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"看看";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self addCornerRadius:self.functionView];
    [self addCornerRadius:self.bottomVoiceView];
    [self addCornerRadius:self.PTZView];
}

- (void)setUp{
    self.screenHeight = SIZEHEIGHT;
    self.naviHeight = navHight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"云医时代-69"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem.imageInsets = UIEdgeInsetsMake(5, 10, -5,-10);
    self.topConstraint.constant = navHight + 10;
    self.bottomConstraint.constant = SIZEHEIGHT - navHight - 10 - 220;
    LRViewBorderRadius(self.vioceView, 11.5, 0, [UIColor clearColor]);
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.playerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.playerView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.playerView.layer.mask = maskLayer;
    self.preBtn = self.PTZBtn1;
    self.PTZCenterItem.hidden = YES;
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
}
- (IBAction)voiceAction:(UIButton *)sender {
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
    self.qualityView.hidden = !self.qualityView.hidden;
}
- (IBAction)quality:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            //流畅
            break;
        case 101:
            //普通
            break;
        case 102:
            //高清
            break;
        default:
            break;
    }
    self.qualityView.hidden = YES;
    [self.qualityBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
}

- (IBAction)functionViewAction:(UITapGestureRecognizer *)sender {
    NSLog(@"点击了%ld",sender.view.tag);
    switch (sender.view.tag) {
        case 200:
            //云台
            self.PTZView.hidden = NO;
            break;
        case 201:
            //语音
        {
            self.vioceView.hidden = NO;
            self.bottomVoiceView.hidden = NO;
        }
            break;
        case 202:
            //镜头
            break;
        case 203:
            //截图
            break;
        case 204:
            //录像
            break;
        case 205:
            //历史影像
            break;
            
        default:
            break;
    }
}
- (IBAction)PTZChange:(UIButton *)sender {
    [self.preBtn setTitleColor:ColorRgbValue(0x898989) forState:UIControlStateNormal];
    self.preBtn.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = ThemeColor;
    self.preBtn = sender;
    switch (sender.tag) {
        case 300:
            self.PTZCenterItem.hidden = YES;
            break;
        case 301:
            self.PTZCenterItem.hidden = NO;
            self.PTZImageView.image = [UIImage imageNamed:@"云医时代-91"];
            self.PTZLabel.text = @"收藏位置后，方便摄像头快速定位";
            break;
        case 302:
            self.PTZCenterItem.hidden = NO;
            self.PTZImageView.image = [UIImage imageNamed:@"云医时代-92"];
            self.PTZLabel.text = @"开启后，一单周围发出声音，摄像机自动转动镜头，对准声音源";
            break;
        default:
            break;
    }
}



- (IBAction)closeVoice:(UIButton *)sender {
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
