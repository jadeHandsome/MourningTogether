//
//  ZFPlayerControlView.h
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

#import <UIKit/UIKit.h>
#import "ZFPortraitControlView.h"
#import "ZFLandScapeControlView.h"
#import "ZFCoverControlView.h"
#import "ZFPlayerItem.h"
#import "ZFUtilities.h"

@interface ZFPlayerControlView : UIView
/// delegate
@property (nonatomic, weak) id<ZFControlViewDelegate> delegate;
/// 是否显示了控制层
@property (nonatomic, assign, readonly, getter = isShowing) BOOL showing;
/// 竖屏控制层的View
@property (nonatomic, strong) ZFPortraitControlView *portraitControlView;
/// 横屏控制层的View
@property (nonatomic, strong) ZFLandScapeControlView *landScapeControlView;
/// 上次播放至xx秒(默认0)
@property (nonatomic, assign) NSInteger viewTime;

/** 
 * 重置controlView
 */
- (void)zf_playerResetControlView;

/** 
 * 开始准备播放
 */
- (void)zf_startReadyToPlay;

/** 
 * 显示控制层
 */
- (void)zf_showControl;

/** 
 * 隐藏控制层
 */
- (void)zf_hideControl;

/** 
 * 取消延时隐藏controlView的方法
 */
- (void)zf_playerCancelAutoFadeOutControlView;

/** 
 * 延迟隐藏控制层
 */
- (void)zf_autoFadeOutControlView;

/** 
 * 显示快进视图
 */
- (void)zf_showFastView:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd;

/** 
 * 设置音量或者亮度的tip
 */
- (void)zf_setTipType:(ZFTipViewType)type withValue:(CGFloat)value;

/** 
 * 加载失败, 显示加载失败按钮
 */
- (void)zf_loadFailed;

/**
 * 开始loading
 */
- (void)zf_startLoding;

/**
 * 结束loading
 */
- (void)zf_stopLoading;

/** 
 * 播放完了, 显示重播按钮 
 */
- (void)zf_playDidEnd;

/**
 *  播放完成时隐藏控制层
 */
- (void)zf_playEndHideControlView;

@end
