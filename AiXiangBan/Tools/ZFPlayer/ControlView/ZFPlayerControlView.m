//
//  ZFPlayerControlView.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPlayerControlView.h"
#import "MMMaterialDesignSpinner.h"
#import "ZFPlayer.h"

static const CGFloat ZFPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat ZFPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ZFPlayerControlView ()
/// 加载loading
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/// 快进快退View
@property (nonatomic, strong) UIView                  *fastView;
/// 快进快退进度progress
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/// 快进快退ImageView
@property (nonatomic, strong) UIImageView             *fastImageView;
/// 加载失败按钮
@property (nonatomic, strong) UIButton                *failBtn;
/// 重播按钮
@property (nonatomic, strong) UIButton                *repeatBtn;
/// 观看记录View
@property (nonatomic, strong) UIView                  *watchrRecordView;
/// 关闭观看记录按钮
@property (nonatomic, strong) UIButton                *closeWatchrRecordBtn;
/// 上次观看至00:00
@property (nonatomic, strong) UILabel                 *watchrRecordLabel;
/// 跳转播放
@property (nonatomic, strong) UIButton                *jumpPlayBtn;
//// 关闭按钮
@property (nonatomic, strong) UIButton                *closeBtn;
/// 声音、亮度layer
@property (nonatomic, strong) CAShapeLayer            *tipLayer;
/// 声音、亮度容器layer
@property (nonatomic, strong) CAShapeLayer            *tipContainerLayer;
/// 声音、亮度image
@property (nonatomic, strong) UIImageView             *tipIconImageView;
/// 是否显示了控制层
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/// 是否播放结束
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;

@end

@implementation ZFPlayerControlView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // 添加所有子控件
        [self addAllSubViews];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self makeNotifications];
        
        self.landScapeControlView.hidden = YES;
        
        // 初始化时重置controlView
        [self zf_playerResetControlView];

    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self hideTipView];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_w = min_view_w;
    min_h = min_view_h;
    self.portraitControlView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.landScapeControlView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 45;
    min_h = 45;
    self.activity.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.activity.center = self.center;
    
    min_w = 100;
    min_h = 100;
    self.repeatBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.repeatBtn.center = self.center;
    
    min_w = 150;
    min_h = 30;
    self.failBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.failBtn.center = self.center;
    
    min_w = 125;
    min_h = 80;
    self.fastView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fastView.center = self.center;
    
    min_w = 32;
    min_x = (self.fastView.width - min_w) / 2;
    min_y = 5;
    min_h = 32;
    self.fastImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = self.fastImageView.bottom + 2;
    min_w = self.fastView.width;
    min_h = 20;
    self.fastTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 12;
    min_y = self.fastTimeLabel.bottom + 10;
    min_w = self.fastView.width - 2 * min_x;
    min_h = 20;
    self.fastProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_h = 30;
    min_y = min_view_h - min_h - 50;
    min_w = 220;
    self.watchrRecordView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 5;
    min_y = 2.5;
    min_w = 25;
    min_h = 25;
    self.closeWatchrRecordBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.closeWatchrRecordBtn.right;
    min_w = 120;
    self.watchrRecordLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.watchrRecordLabel.centerY = self.closeWatchrRecordBtn.centerY;
    
    min_x = self.watchrRecordLabel.right;
    min_y = 0;
    min_w = 70;
    min_h = 25;
    self.jumpPlayBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.jumpPlayBtn.centerY = self.watchrRecordLabel.centerY;
    
    min_w = 25;
    min_h = 25;
    min_x = self.right - min_w;
    min_y = self.top;
    self.closeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/**
 *  添加所有子控件
 */
- (void)addAllSubViews {
    [self addSubview:self.portraitControlView];
    [self addSubview:self.landScapeControlView];
    [self addSubview:self.activity];
    [self addSubview:self.repeatBtn];
    [self addSubview:self.failBtn];
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.fastView];
    [self.fastView addSubview:self.fastImageView];
    [self.fastView addSubview:self.fastTimeLabel];
    [self.fastView addSubview:self.fastProgressView];
    
    [self addSubview:self.watchrRecordView];
    [self.watchrRecordView addSubview:self.closeWatchrRecordBtn];
    [self.watchrRecordView addSubview:self.watchrRecordLabel];
    [self.watchrRecordView addSubview:self.jumpPlayBtn];
    [self addSubview:self.tipIconImageView];

    [self.layer addSublayer:self.tipContainerLayer];
    [self.tipContainerLayer addSublayer:self.tipLayer];
}

// 设置子控件的响应事件
- (void)makeSubViewsAction {
    [self.failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeWatchrRecordBtn addTarget:self action:@selector(closeWatchrRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.jumpPlayBtn addTarget:self action:@selector(jumpPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)makeNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

#pragma mark - Action

/** 播放失败按钮的点击 */
- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_failButtonClick)]) {
        [self.delegate zf_failButtonClick];
    }
}

- (void)closeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_closeButtonClick)]) {
        [self.delegate zf_closeButtonClick];
    }
}

/** 重播按钮的点击 */
- (void)repeatBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_repeatButtonClick)]) {
        [self.delegate zf_repeatButtonClick];
    }
}

/** 关闭播放记录按钮事件 */
- (void)closeWatchrRecordBtnClick:(UIButton *)sender {
    [self hideWatchrRecordView];
}

/** 跳转播放按钮事件 */
- (void)jumpPlayBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_jumpPlayButtonClick:)]) {
        [self.delegate zf_jumpPlayButtonClick:self.viewTime];
    }
    [self hideWatchrRecordView];
}

#pragma mark - Private Method

/**
 *  显示控制层
 */
- (void)showControlView {
    if (ZFPlayer_Shared.isFullScreen) {
        // 横屏
        self.portraitControlView.hidden = YES;
        [self.landScapeControlView zf_showControlView];
        self.closeBtn.hidden = YES;
    } else {
        if (ZFPlayer_Shared.isShrink) { /// 小屏
            self.portraitControlView.hidden = YES;
            self.landScapeControlView.hidden = YES;
            self.closeBtn.hidden = NO;
        } else { /// 竖屏
            self.portraitControlView.hidden = NO;
            self.landScapeControlView.hidden = YES;
            self.closeBtn.hidden = YES;
        }
    }
    ZFPlayer_Shared.statusBarHidden = NO;
}

/**
 *  隐藏控制层
 */
- (void)hideControlView {
    [self.landScapeControlView zf_hideControlView];
    self.portraitControlView.hidden = YES;
    if (ZFPlayer_Shared.isFullScreen && !self.playeEnd) {
        ZFPlayer_Shared.statusBarHidden = YES;
    }
    if (ZFPlayer_Shared.isShrink) {
        self.watchrRecordView.hidden = YES;
        self.closeBtn.hidden = NO;
    }
}

/** 显示观看记录层 */
- (void)showWatchrRecordView:(NSInteger)viewTime {
    NSInteger proMin = viewTime / 60; // 秒
    NSInteger proSec = viewTime % 60; // 分钟
    self.watchrRecordLabel.text = [NSString stringWithFormat:@"上次观看至 %02zd:%02zd", proMin, proSec];
    if (!ZFPlayer_Shared.isShrink) {
        self.watchrRecordView.hidden = NO;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWatchrRecordView) object:nil];
    [self performSelector:@selector(hideWatchrRecordView) withObject:nil afterDelay:5.0];
}

/** 隐藏观看记录层 */
- (void)hideWatchrRecordView {
    self.watchrRecordView.hidden = YES;
    self.viewTime = 0;
}


- (void)hideTipView {
    self.tipLayer.hidden = YES;
    self.tipContainerLayer.hidden = YES;
    self.tipIconImageView.hidden = YES;
}

- (void)volumeChanged:(NSNotification *)notification {
    CGFloat outputVolume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self zf_setTipType:ZFTipViewTypeVolume withValue:outputVolume];
}

#pragma mark - Public method

/** 初始化时重置controlView */
- (void)zf_playerResetControlView {
    [self.portraitControlView zf_playerResetControlView];
    [self.landScapeControlView zf_playerResetControlView];
    
    self.fastView.hidden = YES;
    self.repeatBtn.hidden = YES;
    self.failBtn.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.showing = NO;
    self.playeEnd = NO;
    
    self.watchrRecordView.hidden = YES;
    self.viewTime = 0;
}

/**
 *  开始准备播放
 */
- (void)zf_startReadyToPlay {
    if (self.viewTime) {
        [self showWatchrRecordView:self.viewTime];
    }
    
    // 显示controlView
    [self zf_showControl];
    
    [self zf_readyToPlay];
}

/** 显示控制层 */
- (void)zf_showControl {
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self zf_autoFadeOutControlView];
    }];
}

/** 隐藏控制层 */
- (void)zf_hideControl {
    if (ZFPlayer_Shared.dragged) { return; }
//    if (!self.isShowing) { return; }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/** 显示快进视图 */
- (void)zf_showFastView:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd {
    [self.activity stopAnimating];
    
    NSString *currentTimeStr = [ZFUtilities convertTimeSecond:draggedTime];
    NSString *totalTimeStr   = [ZFUtilities convertTimeSecond:totalTime];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    if (forawrd) {
        self.fastImageView.image = ZFPlayer_Image(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = ZFPlayer_Image(@"ZFPlayer_fast_backward");
    }
    self.fastView.hidden           = NO;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFastView) object:nil];
    [self performSelector:@selector(hideFastView) withObject:nil afterDelay:1];
}

/** 隐藏快进视图 */
- (void)hideFastView {
    self.fastView.hidden = YES;
}

- (void)zf_setTipType:(ZFTipViewType)type withValue:(CGFloat)value {

    self.tipIconImageView.hidden = NO;
    self.tipContainerLayer.hidden = NO;
    self.tipLayer.hidden = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(CGRectGetWidth(self.bounds) - 29, self.center.y+50);;
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(point.x, point.y-100)];
    self.tipContainerLayer.path = path.CGPath;
    self.tipIconImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 37, point.y - 125, 16, 16);
    self.tipLayer.strokeEnd = value;
    self.tipLayer.path = path.CGPath;
    if (type == ZFTipViewTypeBrightness) {
        self.tipIconImageView.image = ZFPlayer_Image(@"ZFPlayer_brightness");
    } else if (type == ZFTipViewTypeVolume) {
        self.tipIconImageView.image = ZFPlayer_Image(@"ZFPlayer_voice");
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTipView) object:nil];
    [self performSelector:@selector(hideTipView) withObject:nil afterDelay:2];
}

/** 准备开始播放, 隐藏loading */
- (void)zf_readyToPlay {
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
}

/** 加载失败, 显示加载失败按钮 */
- (void)zf_loadFailed {
    [self.activity stopAnimating];
    self.failBtn.hidden = NO;
}

/** 开始loading */
- (void)zf_startLoding {
    [self.activity startAnimating];
    self.failBtn.hidden = YES;
    self.fastView.hidden = YES; //
    self.playeEnd = NO;
}
- (void)zf_stopLoading {
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
    self.fastView.hidden = YES; //
    self.playeEnd = NO;
}

/** 播放完了, 显示重播按钮 */
- (void)zf_playDidEnd {
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
    self.repeatBtn.hidden = NO;
    
    self.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self zf_playEndHideControlView];
    ZFPlayer_Shared.statusBarHidden = NO;
}

/**
 *  播放完成时隐藏控制层
 */
- (void)zf_playEndHideControlView {
    if (ZFPlayer_Shared.isFullScreen) {
        // 横屏
        self.portraitControlView.hidden = YES;
        self.landScapeControlView.hidden = NO;
        [self.landScapeControlView zf_playDidEnd];
    } else {
        // 竖屏
        self.landScapeControlView.hidden = YES;
        self.portraitControlView.hidden = NO;
        [self.portraitControlView zf_playDidEnd];
    }
    ZFPlayer_Shared.statusBarHidden = NO;
}


/**
 *  自动隐藏控制层
 */
- (void)zf_autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zf_hideControl) object:nil];
    [self performSelector:@selector(zf_hideControl) withObject:nil afterDelay:ZFPlayerAnimationTimeInterval];
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)zf_playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zf_hideControl) object:nil];
}

#pragma mark - getter

- (ZFPortraitControlView *)portraitControlView {
    if (!_portraitControlView) {
        _portraitControlView = [[ZFPortraitControlView alloc] init];
    }
    return _portraitControlView;
}

- (ZFLandScapeControlView *)landScapeControlView {
    if (!_landScapeControlView) {
        _landScapeControlView = [[ZFLandScapeControlView alloc] init];
    }
    return _landScapeControlView;
}

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }
    return _failBtn;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:ZFPlayer_Image(@"ZFPlayer_repeat_video") forState:UIControlStateNormal];
    }
    return _repeatBtn;
}

- (UIView *)watchrRecordView {
    if (!_watchrRecordView) {
        _watchrRecordView                     = [[UIView alloc] init];
        _watchrRecordView.backgroundColor     = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _watchrRecordView.layer.cornerRadius  = 2;
        _watchrRecordView.layer.masksToBounds = YES;
    }
    return _watchrRecordView;
}

- (UIButton *)closeWatchrRecordBtn {
    if (!_closeWatchrRecordBtn) {
        _closeWatchrRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeWatchrRecordBtn setImage:ZFPlayer_Image(@"ZFPlayer_closeWatch") forState:UIControlStateNormal];
    }
    return _closeWatchrRecordBtn;
}

- (UILabel *)watchrRecordLabel {
    if (!_watchrRecordLabel) {
        _watchrRecordLabel               = [[UILabel alloc] init];
        _watchrRecordLabel.text          = @"上次观看至00:00";
        _watchrRecordLabel.textColor     = [UIColor whiteColor];
        _watchrRecordLabel.textAlignment = NSTextAlignmentCenter;
        _watchrRecordLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _watchrRecordLabel;
}

- (UIButton *)jumpPlayBtn {
    if (!_jumpPlayBtn) {
        _jumpPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpPlayBtn setTitle:@"跳转播放" forState:UIControlStateNormal];
        [_jumpPlayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _jumpPlayBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _jumpPlayBtn;
}

- (UIImageView *)tipIconImageView {
    if (!_tipIconImageView) {
        _tipIconImageView = [[UIImageView alloc] init];
        _tipIconImageView.hidden = YES;
    }
    return _tipIconImageView;
}

- (CAShapeLayer *)tipContainerLayer {
    if (!_tipContainerLayer) {
        _tipContainerLayer = [CAShapeLayer layer];
        _tipContainerLayer.lineWidth = 3;
        _tipContainerLayer.strokeColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
        _tipContainerLayer.strokeEnd = 1;
    }
    return _tipContainerLayer;
}

- (CAShapeLayer *)tipLayer {
    if (!_tipLayer) {
        _tipLayer = [CAShapeLayer layer];
        _tipLayer.lineWidth = 3;
        _tipLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _tipLayer;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:ZFPlayer_Image(@"ZFPlayer_close") forState:UIControlStateNormal];
    }
    return _closeBtn;
}

@end
