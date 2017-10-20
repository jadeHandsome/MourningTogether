//
//  ZFAVPlayerManager.m
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

#import "ZFAVPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayerItem.h"

@interface ZFPlayerLayerView : UIView
@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@property (nonatomic,copy) NSString *videoGravity;
@property (nonatomic, assign) ZFPlayerScalingMode scalingMode;
- (void)playerLayerWithPlayer:(AVPlayer *)player;

@end

@implementation ZFPlayerLayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scalingMode = ZFPlayerScalingModeResizeAspect;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (void)setPlayerLayer:(AVPlayerLayer *)playerLayer {
    _playerLayer = playerLayer;
    [self.layer insertSublayer:playerLayer atIndex:0];
    self.playerLayer.videoGravity = self.videoGravity;
    [self setNeedsLayout]; 
    [self layoutIfNeeded];
}

#pragma mark - public method

- (void)playerLayerWithPlayer:(AVPlayer *)player {
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.playerLayer = playerLayer;
}

- (void)setScalingMode:(ZFPlayerScalingMode)scalingMode {
    switch (scalingMode) {
        case ZFPlayerScalingModeResize:
            self.videoGravity = AVLayerVideoGravityResize;
            break;
        case ZFPlayerScalingModeResizeAspect:
            self.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case ZFPlayerScalingModeResizeAspectFill:
            self.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
}

@end

@interface ZFAVPlayerManager()

/// 播放属性
@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) AVURLAsset             *urlAsset;
@property (nonatomic, strong) AVAssetImageGenerator  *imageGenerator;
@property (nonatomic, strong) id                     timeObserve;
/// playerLayerView
@property (nonatomic, strong) ZFPlayerLayerView      *layerView;
/// 播放状态
@property (nonatomic, assign) ZFPlayerState          state;
/// 播放模型
@property (nonatomic, strong) ZFPlayerItem           *playItem;

@end

@implementation ZFAVPlayerManager

+ (instancetype)zf_playerItem:(ZFPlayerItem *)playerItem {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.playItem = playerItem;
    return playerManager;
}

- (void)zf_initPlayerWithUrl:(NSURL *)url {
    self.urlAsset = [AVURLAsset assetWithURL:url];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 设置playerLayer
    [self.layerView playerLayerWithPlayer:self.player];
    
    [self addPlayTimer];
    [self addPlayerItemObserver];
    ZFPlayer_Shared.pauseByUser = NO;
}

#pragma mark - getter

- (ZFPlayerLayerView *)layerView {
    if (!_layerView) {
        _layerView = [[ZFPlayerLayerView alloc] init];
    }
    return _layerView;
}

- (UIView *)playerLayerView {
    return self.layerView;
}

- (void)setScalingMode:(ZFPlayerScalingMode)scalingMode {
    self.layerView.scalingMode = scalingMode;
}

- (void)setState:(ZFPlayerState)state {
    _state = state;
    if ([self.delegate respondsToSelector:@selector(zf_changePlayerState:)]) {
        [self.delegate zf_changePlayerState:state];
    }
}

#pragma mark - 应用进入后台

- (void)zf_appWillEnterBackground {
    ZFPlayer_Shared.lockScreen = YES;
    ZFPlayer_Shared.didEnterBackground = YES;
    [self.player pause];
    self.state = ZFPlayerStatePause;
}

- (void)zf_appDidEnterPlayground {
    // 根据是否锁定屏幕方向 来恢复单例里锁定屏幕的方向
    ZFPlayer_Shared.lockScreen = ZFPlayer_Shared.fullScreen;
    ZFPlayer_Shared.didEnterBackground = NO;
    if (!ZFPlayer_Shared.isPauseByUser) {
        [self zf_play];
        self.state = ZFPlayerStatePlaying;
        ZFPlayer_Shared.pauseByUser = NO;
    }
}

#pragma mark - 添加KVO通知

- (void)addPlayerItemObserver {
    if (self.playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        // 缓冲区有足够数据可以播放了
        [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)addPlayTimer {
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            [weakSelf.delegate zf_currentPlaybackTime:CMTimeGetSeconds(weakSelf.playerItem.currentTime) totalDuration:CMTimeGetSeconds(weakSelf.playerItem.duration)];
        }
    }];
}

#pragma mark - 移除KVO

- (void)removePlayerItemObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

#pragma mark - 通知/KVO回调

// 播放结束通知
- (void)playDidEnd:(NSNotification *)notification {
    self.state = ZFPlayerStateStoped;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            switch (self.player.currentItem.status) {
                case AVPlayerItemStatusUnknown:
                    self.state = ZFPlayerStateUnknow;
                    break;
                case AVPlayerItemStatusReadyToPlay: {
                    self.state = ZFPlayerStateReadyToPlay;
                    // 跳到xx秒播放视频
                    if (self.playItem.seekTime) {
                        [self zf_seekToTime:self.playItem.seekTime completionHandler:nil];
                        self.playItem.seekTime = 0;
                    }
                }
                    break;
                case AVPlayerItemStatusFailed:
                    self.state = ZFPlayerStateFailed;
                    break;
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            [self.delegate zf_bufferDuration:timeInterval totalDuration:CMTimeGetSeconds(self.playerItem.duration)];
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            // 当缓冲是空的时候
            if (self.playerItem.isPlaybackBufferEmpty) {
                self.state = ZFPlayerStateBuffering;
            }
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            if ([change[NSKeyValueChangeNewKey] isEqualToValue:change[NSKeyValueChangeOldKey]]) {
                return;
            }
            
            // 当缓冲好的时候
            if (self.playerItem.playbackLikelyToKeepUp && self.state == ZFPlayerStateBuffering){
                self.state = ZFPlayerStatePlaying;
            }
        }
    }
}


/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */

- (NSTimeInterval)availableDuration {
    CMTimeRange timeRange     = [self timeRange];
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (CMTimeRange)timeRange {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    return [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
}

// 计算当前在第几秒
- (NSTimeInterval)currentSecond {
    return _playerItem.currentTime.value * 1.0 / _playerItem.currentTime.timescale;
}

#pragma mark - 播放控制

- (void)zf_prepareToPlay {
    __weak typeof(self) wself = self;
    [self zf_seekToTime:self.playItem.seekTime completionHandler:^(BOOL finished) {
        if (finished) {
            wself.state = ZFPlayerStateReadyToPlay;
            [wself zf_play];
            ZFPlayer_Shared.playDidEnd = NO;
        }
    }];
    if ([self.delegate respondsToSelector:@selector(zf_playerReadyToPlay)]) {
        [self.delegate zf_playerReadyToPlay];
    }
}

- (void)zf_play {
    if (self.state == ZFPlayerStateReadyToPlay || self.state == ZFPlayerStatePause || self.state == ZFPlayerStateBuffering) {
        [self.player play];
        ZFPlayer_Shared.pauseByUser = NO;
        if (self.player.rate > 0) {
            self.state = ZFPlayerStatePlaying;
        }
    }
}

- (void)zf_pause {
    if (self.state == ZFPlayerStatePlaying || self.state == ZFPlayerStateBuffering) {
        [self.player pause];
        self.state = ZFPlayerStatePause;
        ZFPlayer_Shared.pauseByUser = YES;
    }
}

- (void)zf_stop {
    [self.player setRate:0.0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removePlayerItemObserver];
    
    [self.player removeTimeObserver:self.timeObserve];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerLayerView removeFromSuperview];
    
    self.timeObserve = nil;
    self.urlAsset = nil;
    self.imageGenerator = nil;
    self.layerView = nil;
    self.playerItem = nil;
    self.player = nil;
}

- (void)zf_seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        if (self.state == ZFPlayerStateStoped) {
            self.state = ZFPlayerStateReadyToPlay;
        }
        
        // 转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            // 只要快进, 就不是被用户暂停
            ZFPlayer_Shared.pauseByUser = NO;
            
        }];
    }
}

#pragma mark - 释放对象

- (void)dealloc {
    [self zf_stop];
}

@end
