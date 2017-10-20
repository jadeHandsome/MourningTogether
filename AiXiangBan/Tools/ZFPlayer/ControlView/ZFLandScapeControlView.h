//
//  ZFLandScapeControlView.h
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
#import "ZFUtilities.h"

@interface ZFLandScapeControlView : UIView

/// delegate
@property (nonatomic, weak) id<ZFControlViewDelegate> delegate;
/// 播放模型
@property (nonatomic, strong) ZFPlayerItem            *playerItem;
/// 播放模型数组
@property (nonatomic, copy) NSArray<ZFPlayerItem *>   *playerItems;
/** 
 重置ControlView 
 */
- (void)zf_playerResetControlView;

/**
 * 播放结束
 */
- (void)zf_playDidEnd;

/**
 * 更新播放模型
 */
- (void)zf_playerItem:(ZFPlayerItem *)playerItem;

/**
 * 更新播放/暂停按钮显示
 */
- (void)zf_playPauseButton:(BOOL)isPlay;

/** 
 * 更新打开/关闭弹幕显示
 */
- (void)zf_openCloseBarrageButton:(BOOL)isOpen;

/**
 * 显示控制层
 */
- (void)zf_showControlView;

/**
 * 隐藏控制层
 */
- (void)zf_hideControlView;

/**
 * 更新缓冲进度
 *
 * @param bufferDuration 视频缓冲的时间
 * @param durtion 视频总时长
 */
- (void)zf_bufferDuration:(NSTimeInterval)bufferDuration totalDurtion:(NSTimeInterval)durtion;

/**
 * 更新视频总时长、当前播放时间、播放进度
 * 
 * @param currentPlaybackTime 当前播放时间
 * @param durtion 视频总时长
 */
- (void)zf_currentPlaybackTime:(NSTimeInterval)currentPlaybackTime totalDurtion:(NSTimeInterval)durtion;

@end
