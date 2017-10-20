//
//  ZFAVPlayerManager.h
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
#import <AVFoundation/AVFoundation.h>
#import "ZFUtilities.h"

@interface ZFAVPlayerManager : NSObject
/// delegate
@property (nonatomic, weak) id<ZFPlayerManagerDelegate> delegate;
/// playerLayerView
@property (nonatomic, strong, readonly) UIView *playerLayerView;
/// 视频的填充模式
@property (nonatomic, assign) ZFPlayerScalingMode scalingMode;

/**
 * 初始化
 *
 * @param playerItem 播放的模型
 */
+ (instancetype)zf_playerItem:(ZFPlayerItem *)playerItem;

/**
 * 设置播放的URL
 */
- (void)zf_initPlayerWithUrl:(NSURL *)url;

/**
 * 准备播放
 */
- (void)zf_prepareToPlay;

/**
 *  播放
 */
- (void)zf_play;

/**
 *  暂停
 */
- (void)zf_pause;

/**
 *  停止
 */
- (void)zf_stop;

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)zf_seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler;

@end
