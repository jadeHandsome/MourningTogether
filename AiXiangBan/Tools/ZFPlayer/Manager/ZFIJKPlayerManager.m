//
//  ZFIJKPlayerManager.m
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

#import "ZFIJKPlayerManager.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <AVFoundation/AVFoundation.h>

@interface ZFIJKPlayerManager ()
/// 视频/直播 播放器
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/// 定时器
@property (nonatomic, weak) NSTimer *timer;
/// 是否初始化播放过
@property (nonatomic, assign, getter=isInitReadyToPlay) BOOL initReadyToPlay;
/// 播放状态
@property (nonatomic, assign) ZFPlayerState state;
/// 播放模型
@property (nonatomic, strong) ZFPlayerItem  *playerItem;
@end

@implementation ZFIJKPlayerManager

- (void)dealloc {
    [self zf_stop];
}

+ (instancetype)zf_playerItem:(ZFPlayerItem *)playerItem {
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    playerManager.playerItem = playerItem;
    return playerManager;
}

/**
 根据视频url初始化player

 @param url 视频连接
 */
- (void)zf_initPlayerWithUrl:(NSURL *)url {
    //IJKplayer属性参数设置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    /// 如果是rtsp协议，可以优先用tcp(默认是用udp)
    // [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    /// 帧速率（fps）可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    
    /// 播放前的探测Size，默认是1M, 改小一点会出画面更快
    [options setFormatOptionIntValue:1024 * 0.5 forKey:@"probesize"];
    ///
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
    /// 解码参数，画面更清晰
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
    /// 1(开启硬件解码,CPU消耗低) 0(软解,更稳定)
    [options setOptionIntValue:0 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    /// 最大fps
    [options setOptionIntValue:60 forKey:@"max-fps" ofCategory:kIJKFFOptionCategoryPlayer];
    /// 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推）
    [options setPlayerOptionIntValue:256 forKey:@"vol"];
    /// 播放前的探测时间(达不到秒开，首屏显示慢，把播放前探测时间改为1)
    [options setFormatOptionIntValue:50000 forKey:@"analyzeduration"];
    /// 超时时间，timeout参数只对http设置有效，若果你用rtmp设置timeout，ijkplayer内部会忽略timeout参数。rtmp的timeout参数含义和http的不一样。
    [options setFormatOptionIntValue:30 * 1000 * 1000 forKey:@"timeout"];
    
//    Boolean _isLive = NO;
//    if (_isLive) {
//        // Param for living
//        [options setPlayerOptionIntValue:3000 forKey:@"max_cached_duration"];   // 最大缓存大小是3秒，可以依据自己的需求修改
//        [options setPlayerOptionIntValue:1 forKey:@"infbuf"];  // 无限读
//        [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];  //  关闭播放器缓冲
//    } else {
//        // Param for playback
//        [options setPlayerOptionIntValue:0 forKey:@"max_cached_duration"];
//        [options setPlayerOptionIntValue:0 forKey:@"infbuf"];
//        [options setPlayerOptionIntValue:1 forKey:@"packet-buffering"];
//    }
    
    // 跳帧开关，如果cpu解码能力不足，可以设置成5，否则
    // 会引起音视频不同步，也可以通过设置它来跳帧达到倍速播放
    // [options setPlayerOptionIntValue:5 forKey:@"framedrop"];

    // videotoolbox-max-frame-width 指定最大宽度
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    //设置缓存大小，太大了没啥用,太小了视频就处于边播边加载的状态，目前是10M，后期可以调整
    [self.player setPlayerOptionIntValue:10* 1024 *1024 forKey:@"max-buffer-size"];
    
    [self addPlayerNotificationObservers];
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

#pragma mark - getter

- (void)setScalingMode:(ZFPlayerScalingMode)scalingMode {
    switch (scalingMode) {
        case ZFPlayerScalingModeResize:
            [self.player.view setContentMode:UIViewContentModeScaleToFill];
            break;
        case ZFPlayerScalingModeResizeAspect:
            [self.player.view setContentMode:UIViewContentModeScaleAspectFit];
            break;
        case ZFPlayerScalingModeResizeAspectFill:
            [self.player.view setContentMode:UIViewContentModeScaleAspectFill];
            break;
        default:
            break;
    }
}

- (void)setState:(ZFPlayerState)state {
    _state = state;
    if ([self.delegate respondsToSelector:@selector(zf_changePlayerState:)]) {
        [self.delegate zf_changePlayerState:state];
    }
}

#pragma mark - 更新方法
- (void)update {
    // 播放进度
    [self.delegate zf_currentPlaybackTime:self.player.currentPlaybackTime totalDuration:self.player.duration];
    // 缓冲进度
    [self.delegate zf_bufferDuration:self.player.playableDuration totalDuration:self.player.duration];
}

#pragma mark-加载状态改变
/**
 视频加载状态改变了
 IJKMPMovieLoadStateUnknown == 0
 IJKMPMovieLoadStatePlayable == 1
 IJKMPMovieLoadStatePlaythroughOK == 2
 IJKMPMovieLoadStateStalled == 4
 */
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = self.player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        // 加载完成，即将播放，停止加载的动画，并将其移除
        // NSLog(@"加载状态变成了已经缓存完成，如果设置了自动播放, 会自动播放");
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
        NSLog(@"自动暂停了，loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        self.state = ZFPlayerStateBuffering;
        
    } else if ((loadState & IJKMPMovieLoadStatePlayable) != 0) {
        NSLog(@"加载状态变成了缓存数据足够开始播放，但是视频并没有缓存完全");
    } else if ((loadState & IJKMPMovieLoadStateUnknown) != 0) {
        NSLog(@"加载状态变成了未知状态 loadStateDidChange: %d\n", (int)loadState);
    }
}

#pragma mark - 播放状态改变

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: 播放完毕: %d\n", reason);
            
            self.state = ZFPlayerStateStoped;
            
            if (!ZFPlayer_Shared.isDragged) { // 如果不是拖拽中，直接结束播放
                ZFPlayer_Shared.playDidEnd = YES;
            }
            
            
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: 用户退出播放: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: 播放出现错误: %d\n", reason);
            
            self.state = ZFPlayerStateFailed;
            
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

// 准备开始播放了
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"加载状态变成了已经缓存完成，如果设置了自动播放, 会自动播放");
    self.state = ZFPlayerStateReadyToPlay;
    NSLog(@"mediaIsPrepareToPlayDidChange");
}

// 播放状态改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
        //视频开始播放的时候开启计时器
        
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(update) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        
    }
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"播放器的播放状态变了，现在是停止状态 %d: stoped", (int)_player.playbackState);
            // 这里的回调也会来多次(一次播放完成, 会回调三次), 所以, 这里不设置
            self.state = ZFPlayerStateStoped;
            
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"播放器的播放状态变了，现在是播放状态 %d: playing", (int)_player.playbackState);
            self.state = ZFPlayerStatePlaying;
            if (!self.isInitReadyToPlay) {
                self.initReadyToPlay = YES;
                if ([self.delegate respondsToSelector:@selector(zf_playerReadyToPlay)]) {
                    [self.delegate zf_playerReadyToPlay];
                }
                
                if (self.playerItem.seekTime) {
                    self.player.currentPlaybackTime = self.playerItem.seekTime;
                    self.playerItem.seekTime = 0; // 滞空, 防止下次播放出错
                    [self.player play];
                }
            }

            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"播放器的播放状态变了，现在是暂停状态 %d: paused", (int)_player.playbackState);
            if (ZFPlayer_Shared.pauseByUser) {
                self.state = ZFPlayerStatePause;
            }
            
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"播放器的播放状态变了，现在是中断状态 %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"播放器的播放状态变了，现在是向前拖动状态:%d forward",(int)self.player.playbackState);
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            NSLog(@"放器的播放状态变了，现在是向后拖动状态 %d: backward", (int)_player.playbackState);
            break;
            
        default: {
            NSLog(@"播放器的播放状态变了，现在是未知状态 %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


#pragma mark - 观察视频播放状态
/**
 准备播放             IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification;
 尺寸改变发出的通知     IJKMPMoviePlayerScalingModeDidChangeNotification;
 播放完成或者用户退出   IJKMPMoviePlayerPlaybackDidFinishNotification;
 播放完成或者用户退出的原因（key） IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey; // NSNumber (IJKMPMovieFinishReason)
 播放状态改变了        IJKMPMoviePlayerPlaybackStateDidChangeNotification;
 加载状态改变了        IJKMPMoviePlayerLoadStateDidChangeNotification;
 AirPlay状态改变了          IJKMPMoviePlayerIsAirPlayVideoActiveDidChangeNotification;
 **/
- (void)addPlayerNotificationObservers {
    /// 准备播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    /// 播放完成或者用户退出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    /// 准备开始播放了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    /// 播放状态改变了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    /// app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(zf_appWillEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    /// app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zf_appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
}

#pragma mark - Public method

- (void)zf_prepareToPlay {
    self.initReadyToPlay = NO;
    [self.player prepareToPlay];
    [self.player play];
    ZFPlayer_Shared.playDidEnd = NO;
}

- (void)zf_play {
    if (self.state == ZFPlayerStateReadyToPlay || self.state == ZFPlayerStatePause || self.state == ZFPlayerStateBuffering) {
        [self.player play];
        ZFPlayer_Shared.pauseByUser = NO;
        if (self.player.playbackRate > 0) {
            self.state = ZFPlayerStatePlaying;
        }
    }
}

- (void)zf_pause {
    if (self.state == ZFPlayerStatePlaying || self.state == ZFPlayerStateBuffering) {
        [self.player pause];
        ZFPlayer_Shared.pauseByUser = YES;
        self.state = ZFPlayerStatePause;
    }
}

- (void)zf_stop {
    [self.player setPlaybackRate:0.0];
    [self.player shutdown];
    
    [self removeMovieNotificationObservers];
    [self.timer invalidate];
    self.timer = nil;
    
    [self.playerLayerView removeFromSuperview];
    self.player = nil;
    self.initReadyToPlay = NO;
}

- (void)zf_seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
    
    NSInteger durMin = dragedSeconds / 60; // 秒
    NSInteger durSec = dragedSeconds % 60; // 分钟
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    NSLog(@"%@",timeString);
    
    // 只要快进, 那么就不是被用户暂停
    ZFPlayer_Shared.pauseByUser = NO;
    
    self.player.currentPlaybackTime = dragedSeconds;
    // 视频跳转回调
    if (completionHandler) { completionHandler(YES); }
    
    [self.player play];
}

- (UIView *)playerLayerView {
    return self.player.view;
}

@end
