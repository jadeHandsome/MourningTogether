//
//  ZFPortraitControlView.m
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

#import "ZFPortraitControlView.h"
#import "ZFPlayer.h"

@interface ZFPortraitControlView ()
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 底部工具栏 */
@property (nonatomic, strong) UIView *bottomToolView;
/** 播放或暂停按钮 */
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/** 播放的当前时间label */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 滑杆 */
@property (nonatomic, strong) UISlider *videoSlider;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) double durationTime;

@end

@implementation ZFPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.backBtn];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.videoSlider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        [self zf_playerResetControlView];
        
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [self.videoSlider addGestureRecognizer:sliderTap];
    
    // slider开始滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBeganAction:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEndedAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
}

#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_backButtonClick)]) {
        [self.delegate zf_backButtonClick];
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(zf_playPauseButtonClick:)]){
        [self.delegate zf_playPauseButtonClick:sender.selected];
    }
}

- (void)progressSliderTouchBeganAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(zf_progressSliderBeginDrag)]) {
        [self.delegate zf_progressSliderBeginDrag];
    }
}

- (void)progressSliderValueChangedAction:(UISlider *)sender {
    // 拖拽过程中修改playTime
    NSString *progressTimeString = [ZFUtilities convertTimeSecond:sender.value * self.durationTime];
    self.currentTimeLabel.text = progressTimeString;
}

- (void)progressSliderTouchEndedAction:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_progressSliderEndDrag:)]) {
        [self.delegate zf_progressSliderEndDrag:sender.value];
    }
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_fullScreenButtonClick)]) {
        [self.delegate zf_fullScreenButtonClick];
    }
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]] && [self.delegate respondsToSelector:@selector(zf_progressSliderTapAction:)]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        
        [self.delegate zf_progressSliderTapAction:tapValue];
    }
}

#pragma mark - 添加子控件约束

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;

    CGFloat min_margin = 9; // label左右的间距

    min_x = 5;
    min_y = 5;
    min_w = 52;
    min_h = 42;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = min_view_h - 39;
    min_w = min_view_w;
    min_h = 39;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 10;
    min_w = 28;
    min_h = min_w;
    min_y = (self.bottomToolView.height - min_h)/2;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtn.right + 4;
    min_y = 0;
    min_w = 48;
    min_h = min_w;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    min_w = 28;
    min_h = min_w;
    min_x = self.bottomToolView.width - min_w - 10;
    min_y = 0;
    self.fullScreenBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fullScreenBtn.centerY = self.playOrPauseBtn.centerY;
    
    min_w = 48;
    min_x = self.fullScreenBtn.x - min_w - 4;
    min_y = 0;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    
    min_x = self.currentTimeLabel.right + min_margin;
    min_y = 0;
    min_w = self.totalTimeLabel.x - min_x - min_margin;
    self.progressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.progressView.centerY = self.playOrPauseBtn.centerY;
    
    min_x = self.progressView.left - 1;
    min_y = 0;
    min_w = self.totalTimeLabel.x - min_x - min_margin;
    min_h = 30;
    self.videoSlider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.videoSlider.centerY = self.playOrPauseBtn.centerY;
    
}

#pragma mark - Public method

/** 重置ControlView */
- (void)zf_playerResetControlView {
#warning xxxxxx
    self.bottomToolView.alpha        = 1;
    self.videoSlider.value           = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.backBtn.alpha               = 1;
}

- (void)zf_playDidEnd {
    self.backBtn.alpha = 1;
    self.bottomToolView.alpha = 0;
}

/**
 更新播放模型
 */
- (void)zf_playerItem:(ZFPlayerItem *)playerItem {
    
}

- (void)zf_playPauseButton:(BOOL)isPlay {
    if (isPlay) {
        self.playOrPauseBtn.selected = YES;
    } else {
        self.playOrPauseBtn.selected = NO;
    }
}

- (void)zf_bufferDuration:(NSTimeInterval)bufferDuration totalDurtion:(NSTimeInterval)durtion {
    CGFloat progress = bufferDuration / durtion;
    self.progressView.progress = progress;
}

- (void)zf_currentPlaybackTime:(NSTimeInterval)currentPlaybackTime totalDurtion:(NSTimeInterval)durtion {
    if (self.bottomToolView.alpha == 0) {
        self.bottomToolView.alpha = 1;
    }

    if (durtion <= 0) return;
    self.durationTime = durtion;
    NSString *durationTimeString = [ZFUtilities convertTimeSecond:durtion];
    self.totalTimeLabel.text = durationTimeString;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentPlaybackTime];
    self.currentTimeLabel.text = currentTimeString;
    
    CGFloat progress = currentPlaybackTime / durtion;
    self.videoSlider.value = progress;
}

#pragma mark - getter

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;

    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UISlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc] init];
        _videoSlider.maximumValue = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];;
        [_videoSlider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
    }
    return _videoSlider;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:ZFPlayer_Image(@"ZFPlayer_fullscreen") forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}


@end
