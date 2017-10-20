//
// ZFPlayer.m
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

#import "ZFPlayer.h"

@interface ZFPlayer () <ZFPlayerManagerDelegate, ZFControlViewDelegate, ZFPlayerViewDelagate>

/// 最底层的父视图
@property (nonatomic, strong) ZFPlayerView       *playerView;
/// ijkPlayer 管理
@property (nonatomic, strong) ZFIJKPlayerManager *ijkPlayerManager;
/// AVPlayer 管理
@property (nonatomic, strong) ZFAVPlayerManager  *avPlayerManager;
/// AV or IJK
@property (nonatomic, assign) ZFPlayerType       type;
/// 用来保存pan手势快进的总时长
@property (nonatomic, assign) CGFloat            sumTime;
/// 播放数据模型
@property (nonatomic, strong) ZFPlayerItem       *playerItem;
/// 播放数据模型数组
@property (nonatomic, copy  ) NSArray<ZFPlayerItem*>    *playerItems;

@end

@implementation ZFPlayer

@synthesize scalingMode         = _scalingMode;
@synthesize currentPlaybackTime = _currentPlaybackTime;
@synthesize duration            = _duration;
@synthesize bufferDuration      = _bufferDuration;
@synthesize isPlaying           = _isPlaying;
@synthesize playerState         = _playerState;
@synthesize mediaFormat         = _mediaFormat;
@synthesize shouldAutoplay      = _shouldAutoplay;
@synthesize view                = _view;

#pragma mark - life cycle 

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldAutoplay = YES;
        // 重置状态模型单例
        [ZFPlayer_Shared playerResetStatusModel];
        // 耳机插入通知
        [self addAudioSessionRouteChangeNotification];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self zf_destroy];
    [ZFPlayer_Shared playerResetStatusModel];
}

#pragma mark - Public method

+ (instancetype)zf_playerWithView:(UIView *)view
                         delegate:(id<ZFPlayerDelegate>)delegate {
    if (view == nil) return nil;
    
    ZFPlayer *player = [[ZFPlayer alloc] init];
    player.delegate  = delegate;
    [player.playerView zf_playerWithView:view];
    return player;
}

- (void)zf_cellPlayerWithViewTag:(NSInteger)viewTag
                              scrollView:(UIScrollView *)scrollView
                               indexPath:(NSIndexPath *)indexPath{

    [self zf_resetPlayer];
    [self.playerView zf_cellPlayerWithViewTag:viewTag scrollView:scrollView indexPath:indexPath];
}

- (void)zf_setPlayerItem:(ZFPlayerItem *)playerItem {
    ZFPlayerType type = [ZFUtilities decoderTypeForContentURL:playerItem.videoURL];
    [self zf_setPlayerItem:playerItem withType:type];
}

- (void)zf_setPlayerItem:(ZFPlayerItem *)playerItem withType:(ZFPlayerType)type {
    self.type = type;
    self.playerItem = playerItem;
    if (self.shouldAutoplay) {
        [self zf_prepareToPlay];
    }
}

- (void)zf_setPlayerItems:(NSArray<ZFPlayerItem *> *)playerItems {
    self.playerItems = playerItems;
    [self zf_setPlayerItem:playerItems.firstObject];
}

- (void)zf_setPlayerItems:(NSArray<ZFPlayerItem *> *)playerItems withType:(ZFPlayerType)type {
    self.playerItems = playerItems;
    [self zf_setPlayerItem:playerItems.firstObject withType:type];
}

- (void)zf_replaceCurrentItemWithPlayerItem:(ZFPlayerItem *)playerItem {
    [self zf_resetPlayer];
    self.playerItem = playerItem;
    [self zf_prepareToPlay];
}

- (void)zf_play {
    if (self.playerState == ZFPlayerStateUnknow) {
        self.shouldAutoplay = YES;
        [self zf_prepareToPlay];
    } else if (self.playerState == ZFPlayerStateStoped) { // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        [self zf_prepareToPlay];
    } else {
        [self.ijkPlayerManager zf_play];
        [self.avPlayerManager zf_play];
    }
}

- (void)zf_pause {
    [self.ijkPlayerManager zf_pause];
    [self.avPlayerManager zf_pause];
}

- (void)zf_stop {
    [self.ijkPlayerManager zf_stop];
    [self.avPlayerManager zf_stop];
}

- (void)zf_prepareToPlay {
    [self configZFPlayer];
    ZFPlayer_Shared.allowLandscape = YES;
    self.playerView.coverControlView.hidden = YES;
    [self.playerView.playerControlView zf_startLoding];
    [self.ijkPlayerManager zf_prepareToPlay];
    [self.avPlayerManager zf_prepareToPlay];
}

/**
 加载失败重新加载player
 */
- (void)zf_reloadPlayer {
    [self configZFPlayer];
    [self zf_prepareToPlay];
}

/**
 销毁视频
 */
- (void)zf_destroy {
    if (ZFPlayer_Shared.isFullScreen) {
        return;
    }
    [self zf_stop];
    ZFPlayer_Shared.didEnterBackground = NO;
    [self.playerView zf_playerResetPlayerView];
    [self.playerView removeFromSuperview];
    self.ijkPlayerManager = nil;
    self.avPlayerManager = nil;
    // 改为为播放完
    ZFPlayer_Shared.playDidEnd = NO;
}

/**
 *  重置player
 */
- (void)zf_resetPlayer {
    [self zf_stop];
    // 改为为播放完
    ZFPlayer_Shared.playDidEnd         = NO;
    ZFPlayer_Shared.didEnterBackground = NO;
    self.ijkPlayerManager = nil;
    self.avPlayerManager = nil;
    
    [self.playerView zf_playerResetPlayerView];
}

#pragma mark - Private method



// 设置Player相关参数
- (void)configZFPlayer {
    // 停掉之前的视频
    [self zf_stop];
    if (self.type == ZFPlayerTypeAV) {
        [self.avPlayerManager zf_initPlayerWithUrl:self.playerItem.videoURL];
        self.playerView.playerLayerView = self.avPlayerManager.playerLayerView;
    } else if (self.type == ZFPlayerTypeIJK) {
        [self.ijkPlayerManager zf_initPlayerWithUrl:self.playerItem.videoURL];
        self.playerView.playerLayerView = self.ijkPlayerManager.playerLayerView;
    }
    
}

- (void)seekToTime:(CGFloat)second replayFadeOutControlView:(BOOL)replay {
    __weak typeof(self) weakSelf = self;
    if (self.type == ZFPlayerTypeIJK) {
        [self.ijkPlayerManager zf_seekToTime:second completionHandler:^(BOOL finished) {
            if (finished) {
                ZFPlayer_Shared.dragged = NO;
                [weakSelf zf_play];
                self.sumTime = 0;
                if (replay) {
                    // 延迟隐藏控制层
                    [weakSelf.playerView.playerControlView zf_autoFadeOutControlView];
                }
            }
        }];
    } else if (self.type == ZFPlayerTypeAV) {
        [self.avPlayerManager zf_seekToTime:second completionHandler:^(BOOL finished) {
            if (finished) {
                ZFPlayer_Shared.dragged = NO;
                [weakSelf zf_play];
                self.sumTime = 0;
                if (replay) {
                    // 延迟隐藏控制层
                    [weakSelf.playerView.playerControlView zf_autoFadeOutControlView];
                }
            }
        }];
    }
}

- (void)addAudioSessionRouteChangeNotification {
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self zf_play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - ZFPlayerManagerDelegate

- (void)zf_changePlayerState:(ZFPlayerState)state {
    _playerState = state;
    switch (state) {
        case ZFPlayerStateReadyToPlay:{
            [self.playerView.playerControlView zf_startLoding];
            [self zf_play];
        }
            break;
        case ZFPlayerStatePlaying: {
            _isPlaying = YES;
            [self.playerView.playerControlView zf_stopLoading];
            [self.playerView.playerControlView.portraitControlView zf_playPauseButton:YES];
            [self.playerView.playerControlView.landScapeControlView zf_playPauseButton:YES];
        }
            break;
        case ZFPlayerStatePause: {
            _isPlaying = NO;
            [self.playerView.playerControlView.portraitControlView zf_playPauseButton:NO];
            [self.playerView.playerControlView.landScapeControlView zf_playPauseButton:NO];
        }
            break;
        case ZFPlayerStateStoped: {
            _isPlaying = NO;
            [self.playerView zf_playDidEnd];
        }
            break;
        case ZFPlayerStateBuffering: {
            [self.playerView.playerControlView zf_startLoding];
        }
            break;
        case ZFPlayerStateFailed: {
            _isPlaying = NO;
            [self.playerView.playerControlView zf_loadFailed];
        }
            break;
        default:
            break;
    }
}

- (void)zf_bufferDuration:(NSTimeInterval)bufferDuration totalDuration:(NSTimeInterval)duration {
    _bufferDuration = bufferDuration;
    _duration = duration;
    [self.playerView.playerControlView.portraitControlView zf_bufferDuration:bufferDuration totalDurtion:duration];
    [self.playerView.playerControlView.landScapeControlView zf_bufferDuration:bufferDuration totalDurtion:duration];

}

- (void)zf_currentPlaybackTime:(NSTimeInterval)currentPlaybackTime totalDuration:(NSTimeInterval)duration {
    _currentPlaybackTime = currentPlaybackTime;
    _duration = duration;
    if (ZFPlayer_Shared.isDragged) { // 在拖拽进度条的时候不应去更新进度条的值
        return;
    }
    [self.playerView.playerControlView.portraitControlView zf_currentPlaybackTime:currentPlaybackTime totalDurtion:duration];
    [self.playerView.playerControlView.landScapeControlView zf_currentPlaybackTime:currentPlaybackTime totalDurtion:duration];
}

/** 播放器准备开始播放时 */
- (void)zf_playerReadyToPlay {
    [self.playerView zf_startReadyToPlay];
}

/** 开始快进时 */
- (void)zf_startPlayerSeekTime {
    [self.playerView.playerControlView zf_startLoding];
}

/** 完成快进时 */
- (void)zf_completionPlayerSeekTime {
    [self.playerView.playerControlView zf_startLoding];
}

#pragma mark - ZFControlViewDelagate

/** 返回按钮被点击 */
- (void)zf_backButtonClick {
    if (ZFPlayer_Shared.isFullScreen) { // 横屏
        // 延迟隐藏控制层
        [self.playerView.playerControlView zf_autoFadeOutControlView];
        [self.playerView zf_shrinkOrFullScreen:NO];
    } else {
        if ([self.delegate respondsToSelector:@selector(zf_playerBackButtonClick)]) {
            [self.delegate zf_playerBackButtonClick];
        }
    }
}
/** 播放暂停按钮被点击 */
- (void)zf_playPauseButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.playerView.playerControlView zf_autoFadeOutControlView];
    
    if (isSelected) {
        [self zf_pause];
    } else {
        // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        if (self.playerState == ZFPlayerStateStoped) {
            [self zf_prepareToPlay]; //
        } else {
            [self zf_play];
        }
    }
}
/** 全屏按钮被点击 */
- (void)zf_fullScreenButtonClick {
    // 延迟隐藏控制层
    [self.playerView.playerControlView zf_autoFadeOutControlView];
    
    [self.playerView zf_shrinkOrFullScreen:YES];
}

/** 发送弹幕按钮被点击 */
- (void)zf_sendBarrageButtonClick {
    // 延迟隐藏控制层
    [self.playerView.playerControlView zf_autoFadeOutControlView];
}

/**
 分辨率按钮被点击
 */
- (void)zf_resolutionButtonClick {
    // 隐藏控制层
    [self.playerView.playerControlView zf_hideControl];
}

/** 切换分辨率 */
- (void)zf_changeResolution:(ZFResolution *)resolution {
    // 延迟隐藏控制层
    [self.playerView.playerControlView zf_autoFadeOutControlView];
    
    self.playerItem.videoURL = [NSURL URLWithString:resolution.url];
    self.playerItem.seekTime = self.currentPlaybackTime;
    [self zf_replaceCurrentItemWithPlayerItem:self.playerItem];
}

/**
 选集按钮被点击
 */
- (void)zf_chooseVideoButtonClick {
    // 隐藏控制层
    [self.playerView.playerControlView zf_hideControl];
}

- (void)zf_changeVideo:(ZFPlayerItem *)playerItem {
    [self zf_replaceCurrentItemWithPlayerItem:playerItem];
}

/**
 下一集被点击
 */
- (void)zf_nextButtonClick {
    NSInteger index = [self.playerItems indexOfObject:self.playerItem];
    if (index == self.playerItems.count-1) {
        NSLog(@"最后一个视频");
    } else {
        ZFPlayerItem *playerItem = self.playerItems[index+1];
        [self zf_replaceCurrentItemWithPlayerItem:playerItem];
    }
}

/** 进度条开始拖动 */
- (void)zf_progressSliderBeginDrag {
    ZFPlayer_Shared.dragged = YES;
    [self.playerView.playerControlView zf_playerCancelAutoFadeOutControlView];
}

/** 进度结束拖动，并返回最后的值 */
- (void)zf_progressSliderEndDrag:(CGFloat)value {
    // 计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(self.duration * value);
    [self seekToTime:dragedSeconds replayFadeOutControlView:YES];
}

/** 进度条tap点击 */
- (void)zf_progressSliderTapAction:(CGFloat)value {
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(self.duration * value);
    [self seekToTime:dragedSeconds replayFadeOutControlView:YES];
}

/** 锁定屏幕方向按钮点击 */
- (void)zf_lockScreenButtonClick {
    [self.playerView.playerControlView zf_showControl];
}

/** 重播按钮被点击 */
- (void)zf_repeatButtonClick {
    [self zf_prepareToPlay];
    [self.playerView zf_prepareToPlay];
    
    // 没有播放完
    ZFPlayer_Shared.playDidEnd = NO;
}

/** 加载失败按钮被点击 */
- (void)zf_failButtonClick {
    [self zf_reloadPlayer];
}

/** 跳转播放按钮被点击 */
- (void)zf_jumpPlayButtonClick:(NSInteger)viewTime {
    if (!viewTime) {
        return;
    }
    [self seekToTime:viewTime replayFadeOutControlView:YES];
}

- (void)zf_coverViewPlayButtonClick {
    [self zf_play];
}

- (void)zf_closeButtonClick {
    [self zf_destroy];
}

#pragma mark - ZFPlayerViewDelagate

/** 双击事件 */
- (void)zf_doubleTapAction {
    if (ZFPlayer_Shared.isPauseByUser) {
        [self zf_play];
    } else {
        [self zf_pause];
    }
}

/** pan开始水平移动 */
- (void)zf_panHorizontalBeginMoved {
    // 给sumTime初值
    self.sumTime = self.currentPlaybackTime;
}

/** pan水平移动ing */
- (void)zf_panHorizontalMoving:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CGFloat totalMovieDuration = self.duration;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    // 拖动中
    ZFPlayer_Shared.dragged = YES;
    // 更新进度
    [self.playerView.playerControlView.portraitControlView zf_currentPlaybackTime:self.sumTime totalDurtion:totalMovieDuration];
    [self.playerView.playerControlView.landScapeControlView zf_currentPlaybackTime:self.sumTime totalDurtion:totalMovieDuration];

    // 展示快进/快退view
    [self.playerView.playerControlView zf_showFastView:self.sumTime totalTime:totalMovieDuration isForward:style];
    
}

/** pan结束水平移动 */
- (void)zf_panHorizontalEndMoved {
    // 拖动结束
    ZFPlayer_Shared.pauseByUser = NO;
    // seekTime
    [self seekToTime:self.sumTime replayFadeOutControlView:NO];
}

- (void)zf_panVerticalMovingType:(ZFTipViewType)type withValue:(CGFloat)value {
    [self.playerView.playerControlView zf_setTipType:type withValue:value];
}

#pragma mark - getter 

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.delegate                                        = self;
        _playerView.playerControlView.delegate                      = self;
        _playerView.playerControlView.portraitControlView.delegate  = self;
        _playerView.playerControlView.landScapeControlView.delegate = self;
        _playerView.coverControlView.delegate                       = self;
    }
    return _playerView;
}

- (UIView *)view {
    return self.playerView;
}

#pragma mark - setter 

- (void)setPlayerItem:(ZFPlayerItem *)playerItem {
    _playerItem = playerItem;
    if (self.type == ZFPlayerTypeAV) {
        self.avPlayerManager = [ZFAVPlayerManager zf_playerItem:playerItem];
        self.avPlayerManager.delegate = self;
    } else {
        self.ijkPlayerManager = [ZFIJKPlayerManager zf_playerItem:playerItem];
        self.ijkPlayerManager.delegate = self;
    }
    /// 同步一些属性
    [self.playerView.coverControlView zf_coverImageViewWithURLString:playerItem.placeholderImageURLString placeholderImage:playerItem.placeholderImage];
    self.playerView.playerControlView.viewTime = playerItem.viewTime;
    [self.playerView.playerControlView.landScapeControlView zf_playerItem:playerItem];
    [self.playerView.playerControlView.portraitControlView zf_playerItem:playerItem];
    self.playerView.playerItem = playerItem;
}

- (void)setPlayerItems:(NSArray<ZFPlayerItem *> *)playerItems {
    _playerItems = playerItems;
    self.playerView.playerControlView.landScapeControlView.playerItems = playerItems;
}

- (void)zf_setScalingMode:(ZFPlayerScalingMode)scalingMode {
    self.ijkPlayerManager.scalingMode = scalingMode;
    self.avPlayerManager.scalingMode = scalingMode;
}

- (void)setView:(UIView *)view {
    self.playerView.parentView = view;
}

- (void)setShouldAutoplay:(BOOL)shouldAutoplay {
    _shouldAutoplay = shouldAutoplay;
    if (shouldAutoplay) {
        [self.playerView.playerControlView zf_startLoding];
        self.playerView.coverControlView.hidden = YES;
    } else {
        [self.playerView.playerControlView zf_stopLoading];
        self.playerView.coverControlView.hidden = NO;
    }
}

- (void)setRootVC:(UIViewController *)rootVC {
    self.playerView.rootVC = rootVC;
}

@end
