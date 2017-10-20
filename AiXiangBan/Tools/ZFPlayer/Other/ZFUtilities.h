//
//  ZFUtilities.m
//  ZFPlayer
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "ZFPlayerItem.h"
@class ZFPlayerItem;
@class ZFResolution;

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 监听TableView的contentOffset
#define kZFPlayerViewContentOffset           @"contentOffset"
// player的单例
#define ZFPlayer_Shared                      [ZFPlayerStatusModel sharedPlayerStatusModel]
// 屏幕的宽
#define ZFPlayer_ScreenWidth                 [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ZFPlayer_ScreenHeight                [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define ZFPlayer_RGBA(r,g,b,a)               [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define ZFPlayer_SrcName(file)               [@"ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayer_FrameworkSrcName(file)      [@"Frameworks/ZFPlayer.framework/ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayer_Image(file)                 [UIImage imageNamed:ZFPlayer_SrcName(file)] ? :[UIImage imageNamed:ZFPlayer_FrameworkSrcName(file)]

#define ZFPlayer_OrientationIsLandscape      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define ZFPlayer_OrientationIsPortrait       UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)

// 操作系统版本号
#define ZFPlayer_IOS_VERSION                 ([[[UIDevice currentDevice] systemVersion] floatValue])

/// 播放器的几种状态
typedef NS_ENUM(NSInteger, ZFPlayerState) {
    ZFPlayerStateUnknow,          // 未初始化的
    ZFPlayerStateFailed,          // 播放失败（无网络，视频地址错误）
    ZFPlayerStateReadyToPlay,     // 可以播放了
    ZFPlayerStateBuffering,       // 缓冲中
    ZFPlayerStatePlaying,         // 播放中
    ZFPlayerStatePause,           // 暂停播放
    ZFPlayerStateStoped           // 播放已停止（需要重新初始化）
};

/// decode type
typedef NS_ENUM(NSUInteger, ZFPlayerType) {
    ZFPlayerTypeError,
    ZFPlayerTypeAV,
    ZFPlayerTypeIJK,
};

/// media format
typedef NS_ENUM(NSUInteger, ZFMediaFormat) {
    ZFMediaFormatError,
    ZFMediaFormatUnknown,
    ZFMediaFormatMP3,
    ZFMediaFormatMPEG4,
    ZFMediaFormatMOV,
    ZFMediaFormatFLV,
    ZFMediaFormatM3U8,
    ZFMediaFormatRTMP,
    ZFMediaFormatRTSP,
};

/// 亮度、声音调节
typedef NS_ENUM(NSInteger, ZFTipViewType){
    ZFTipViewTypeBrightness,    // 亮度调节
    ZFTipViewTypeVolume         // 声音调节
};

/// playerView的type
typedef NS_ENUM(NSInteger, ZFPlayerViewType){
    ZFPlayerViewTypeNormal,            // 普通模式
    ZFPlayerViewTypeTableView,         // tableView
    ZFPlayerViewTypeCollectionView     // collectionView
};

/// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, ZFPlayerScalingMode) {
    ZFPlayerScalingModeResizeAspect,     // 等比例填充，直到一个维度到达区域边界  UIViewContentModeScaleAspectFit
    ZFPlayerScalingModeResize,           // 非均匀模式。两个维度完全填充至整个视图区域 UIViewContentModeScaleToFill
    ZFPlayerScalingModeResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪 UIViewContentModeScaleAspectFill
};

@protocol ZFPlayerPlayback;

@protocol ZFPlayerPlayback <NSObject>
// The current playtime
@property (nonatomic, assign, readonly)  NSTimeInterval currentPlaybackTime;
/// The buffer duration
@property (nonatomic, assign, readonly)  NSTimeInterval bufferDuration;
/// The video total duration
@property (nonatomic, assign, readonly)  NSTimeInterval duration;
/// Whether playing
@property (nonatomic, assign, readonly)  BOOL           isPlaying;
/// Play state
@property (nonatomic, assign, readonly)  ZFPlayerState  playerState;
/// Media format
@property (nonatomic, assign, readonly)  ZFMediaFormat  mediaFormat;
///
@property (nonatomic, strong)  UIView                   *view;
/// Scaling mode
@property (nonatomic, assign) ZFPlayerScalingMode       scalingMode;
/// shouldAutoplay 默认为YES
@property (nonatomic, assign) BOOL                      shouldAutoplay;

- (void)zf_prepareToPlay;
- (void)zf_play;
- (void)zf_pause;
- (void)zf_stop;
- (void)zf_destroy;
- (void)zf_reloadPlayer;

@end

@protocol ZFPlayerManagerDelegate <NSObject>

@required
/**
 视频状态改变时
 */
- (void)zf_changePlayerState:(ZFPlayerState)state;

/**
 播放器准备开始播放时
 */
- (void)zf_playerReadyToPlay;

/**
 缓冲进度改变
 @param bufferDuration 视频缓冲的时间（秒）
 @param duration 视频总时间（秒）
 */
- (void)zf_bufferDuration:(NSTimeInterval)bufferDuration totalDuration:(NSTimeInterval)duration;

/**
 播放进度改变
 @param currentPlaybackTime 视频当前播放的时间（秒）
 @param duration 视频总时间（秒）
 */
- (void)zf_currentPlaybackTime:(NSTimeInterval)currentPlaybackTime totalDuration:(NSTimeInterval)duration;

@end

@protocol ZFControlViewDelegate <NSObject>

/** 
 * 返回按钮被点击
 */
- (void)zf_backButtonClick;

/** 
 * 播放暂停按钮被点击
 */
- (void)zf_playPauseButtonClick:(BOOL)isSelected;

/** 
 * 全屏按钮被点击
 */
- (void)zf_fullScreenButtonClick;

/**
 * 下一个视频按钮被点击
 */
- (void)zf_nextButtonClick;

/**
 * 分辨率按钮被点击
 */
- (void)zf_resolutionButtonClick;

/**
 * 切换分辨率
 */
- (void)zf_changeResolution:(ZFResolution *)resolution;

/**
 * 选集按钮被点击
 */
- (void)zf_chooseVideoButtonClick;

/**
 * 切换分集视频
 */
- (void)zf_changeVideo:(ZFPlayerItem *)playerItem;

/** 
 * 进度条开始拖动
 */
- (void)zf_progressSliderBeginDrag;

/** 
 * 进度结束拖动，并返回最后的值
 */
- (void)zf_progressSliderEndDrag:(CGFloat)value;

/** 
 * 进度条tap点击
 */
- (void)zf_progressSliderTapAction:(CGFloat)value;

/** 
 * 锁定屏幕方向按钮点击
 */
- (void)zf_lockScreenButtonClick;

/** 
 * 重播按钮被点击
 */
- (void)zf_repeatButtonClick;

/** 
 * 加载失败按钮被点击
 */
- (void)zf_failButtonClick;

/** 
 * 跳转播放按钮被点击
 */
- (void)zf_jumpPlayButtonClick:(NSInteger)viewTime;

/** 
 * 封面图play事件
 */
- (void)zf_coverViewPlayButtonClick;

/**
 * 小屏关闭按钮被点击
 */
- (void)zf_closeButtonClick;

@end

@interface ZFUtilities : NSObject

+ (NSString *)convertTimeSecond:(NSInteger)timeSecond;

+ (ZFMediaFormat)mediaFormatForContentURL:(NSURL *)contentURL;

+ (ZFPlayerType)decoderTypeForContentURL:(NSURL *)contentURL;

@end

