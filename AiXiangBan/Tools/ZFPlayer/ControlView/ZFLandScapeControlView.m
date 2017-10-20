//
//  ZFLandScapeControlView.m
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

#import "ZFLandScapeControlView.h"
#import "ZFPlayer.h"
#import "ZFToolView.h"
#define ToolViewWidth 180
static const CGFloat ZFPlayerAnimationTimeInterval = 0.5f;

@interface ZFLandScapeControlView () <ZFToolViewDelegate>

/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮(小)
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 下一个
@property (nonatomic, strong) UIButton *nextBtn;
/// 分辨率按钮
@property (nonatomic, strong) UIButton *resolutionBtn;
/// 选集按钮
@property (nonatomic, strong) UIButton *chooseVideoBtn;
/// 播放的当前时间label
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) UISlider *videoSlider;
/// 缓冲进度条
@property (nonatomic, strong) UIProgressView *progressView;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;
///
@property (nonatomic, assign) double durationTime;

@property (nonatomic, strong) ZFToolView *toolView;

@end

@implementation ZFLandScapeControlView

- (instancetype)init {
    if (self = [super init]) {
        // 添加子控件
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.nextBtn];
        [self.bottomToolView addSubview:self.resolutionBtn];
        [self.bottomToolView addSubview:self.chooseVideoBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.videoSlider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self addSubview:self.lockBtn];        
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        [self zf_playerResetControlView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGFloat min_margin = 9; // label左右的间距
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 60;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 15;
    min_y = 20;
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.backBtn.right + 15;
    min_y = 0;
    min_w = min_view_w - min_x - 15 ;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.centerY = self.backBtn.centerY;
    
    min_x = 0;
    min_h = 40;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 10;
    min_y = 5;
    min_w = 30;
    min_h = 30;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtn.right + 4;
    min_y = 0;
    min_w = 30;
    min_h = 30;
    self.nextBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.nextBtn.centerY = self.playOrPauseBtn.centerY;
    
    min_x = self.nextBtn.right + 4;
    min_y = 0;
    min_w = 50;
    min_h = 30;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    
    min_w = 40;
    min_x = min_view_w - min_margin - min_w;
    min_y = 0;
    min_h = 32;
    self.resolutionBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.resolutionBtn.centerY = self.playOrPauseBtn.centerY;
    
    
    min_w = 40;
    min_x = self.resolutionBtn.left - min_margin - min_w;
    min_y = 0;
    min_h = 32;
    self.chooseVideoBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.chooseVideoBtn.centerY = self.playOrPauseBtn.centerY;
    
    
    min_w = 50;
    min_x = self.chooseVideoBtn.left - min_margin - min_w;
    min_y = 0;
    min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    min_x = self.currentTimeLabel.right + min_margin;
    min_y = 0;
    min_w = self.totalTimeLabel.x - min_margin - min_x;
    min_h = 30;
    self.progressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.progressView.centerY = self.playOrPauseBtn.centerY;
    
    
    min_x = self.progressView.left - 1;
    min_y = 0;
    min_w = self.totalTimeLabel.x - min_margin - min_x;
    min_h = 30;
    self.videoSlider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.videoSlider.centerY = self.playOrPauseBtn.centerY;
    
    
    min_x = min_view_w;
    min_y = 0;
    min_w = ToolViewWidth;
    min_h = min_view_h;
    self.toolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 15;
    min_y = 0;
    min_w = 32;
    min_h = 32;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.centerY = self.centerY;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(nextBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.resolutionBtn addTarget:self action:@selector(resolutionButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseVideoBtn addTarget:self action:@selector(chooseVideoButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    ZFPlayer_Shared.lockScreen = NO;
    self.lockBtn.selected = NO;
    if ([self.delegate respondsToSelector:@selector(zf_backButtonClick)]) {
        [self.delegate zf_backButtonClick];
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(zf_playPauseButtonClick:)]){
        [self.delegate zf_playPauseButtonClick:sender.selected];
    }
}

- (void)nextBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_nextButtonClick)]) {
        [self.delegate zf_nextButtonClick];
    }
}

- (void)resolutionButtonClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_resolutionButtonClick)]) {
        [self.delegate zf_resolutionButtonClick];
    }
    [self.toolView showToolViewWithType:ZFToolViewTypeResolution];
}

- (void)chooseVideoButtonClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_chooseVideoButtonClick)]) {
        [self.delegate zf_chooseVideoButtonClick];
    }
    [self.toolView showToolViewWithType:ZFToolViewTypeVideos];
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    ZFPlayer_Shared.lockScreen = sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_lockScreenButtonClick)]) {
        [self.delegate zf_lockScreenButtonClick];
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

#pragma mark - Public method

/** 
 重置ControlView 
 */
- (void)zf_playerResetControlView {
    self.videoSlider.value           = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.resolutionBtn.selected      = NO;
    self.titleLabel.text             = @"";
#warning xxxx
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
}

- (void)zf_playDidEnd {
    self.topToolView.alpha    = 1;
    self.bottomToolView.alpha = 0;
}

/**
 更新播放模型
 */
- (void)zf_playerItem:(ZFPlayerItem *)playerItem {
    self.playerItem = playerItem;
    self.titleLabel.text = playerItem.title;
}

- (void)zf_playPauseButton:(BOOL)isPlay {
    if (isPlay) {
        self.playOrPauseBtn.selected = YES;
    } else {
        self.playOrPauseBtn.selected = NO;
    }
}

- (void)zf_openCloseBarrageButton:(BOOL)isOpen {
    if (isOpen) {
        self.resolutionBtn.selected = NO;
    } else {
        self.resolutionBtn.selected = YES;
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

- (void)zf_showControlView {
    [UIView animateWithDuration:ZFPlayerAnimationTimeInterval animations:^{
        [self.toolView hiddenToolView];
    } completion:^(BOOL finished) {
        self.hidden = NO;
        self.lockBtn.hidden  = NO;
        self.backgroundColor = ZFPlayer_RGBA(0, 0, 0, 0.3);
        if (ZFPlayer_Shared.lockScreen) {
            self.bottomToolView.hidden = YES;
            self.topToolView.hidden    = YES;
        } else {
            self.bottomToolView.hidden = NO;
            self.topToolView.hidden    = NO;
        }
//        self.toolView.hidden = YES;
    }];
}

- (void)zf_hideControlView {
    [UIView animateWithDuration:ZFPlayerAnimationTimeInterval animations:^{
        self.topToolView.hidden = YES;
        self.bottomToolView.hidden = YES;
        self.lockBtn.hidden = YES;
    }];
}

#pragma mark - ZFToolViewDelegate

- (void)zf_changeResolution:(ZFResolution *)resolution {
    if ([self.delegate respondsToSelector:@selector(zf_changeResolution:)]) {
        [self.delegate zf_changeResolution:resolution];
    }
    [self.toolView hiddenToolView];
}

- (void)zf_changeVideo:(ZFPlayerItem *)playerItem {
    if ([self.delegate respondsToSelector:@selector(zf_changeVideo:)]) {
        [self.delegate zf_changeVideo:playerItem];
    }
    [self.toolView hiddenToolView];
}

#pragma mark - Setter

- (void)setPlayerItems:(NSArray<ZFPlayerItem *> *)playerItems {
    _playerItems = playerItems;
    if (playerItems.count != 0) {
        self.toolView.playerItems = playerItems;
        ZFPlayerItem *playerItem = playerItems.firstObject;
        playerItem.selected = YES;
    }
}

- (void)setPlayerItem:(ZFPlayerItem *)playerItem {
    _playerItem = playerItem;
    if (playerItem.resolution.count != 0) {
        self.toolView.resolutions = playerItem.resolution;
        ZFResolution *resolution = playerItem.resolution.firstObject;
        resolution.selected = YES;
        [self.resolutionBtn setTitle:resolution.title forState:UIControlStateNormal];
    }
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
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

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:ZFPlayer_Image(@"ZFPlayer_next") forState:UIControlStateNormal];
    }
    return _nextBtn;
}

- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resolutionBtn setTitle:@"标清" forState:UIControlStateNormal];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_resolutionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _resolutionBtn;
}

- (UIButton *)chooseVideoBtn {
    if (!_chooseVideoBtn) {
        _chooseVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseVideoBtn setTitle:@"选集" forState:UIControlStateNormal];
        _chooseVideoBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_chooseVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _chooseVideoBtn;
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
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [_videoSlider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
    }
    return _videoSlider;
}

- (UIProgressView *)progressView {
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

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (ZFToolView *)toolView {
    if (!_toolView) {
        _toolView = [[ZFToolView alloc] init];
//        _toolView.hidden = YES;
        _toolView.delegate = self;
    }
    return _toolView;
}

@end
