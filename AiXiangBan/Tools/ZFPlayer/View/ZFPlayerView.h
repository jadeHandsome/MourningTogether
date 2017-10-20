//
//  ZFPlayerView.h
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
#import "ZFPlayerControlView.h"
#import "ZFIJKPlayerManager.h"
#import "ZFAVPlayerManager.h"
@class ZFPlayerItem;

typedef NS_ENUM(NSInteger, ZFPlayerViewScreenState) {
    ZFPlayerViewScreenStateSmall,
    ZFPlayerViewScreenStateAnimating,
    ZFPlayerViewScreenStateFullScreen
};

@protocol ZFPlayerViewDelagate <NSObject>
@optional
/** 
 * 双击事件
 */
- (void)zf_doubleTapAction;

/** 
 * pan开始水平移动
 */
- (void)zf_panHorizontalBeginMoved;

/** 
 * pan水平移动ing
 */
- (void)zf_panHorizontalMoving:(CGFloat)value;

/** 
 * pan结束水平移动
 */
- (void)zf_panHorizontalEndMoved;

/** 
 * pan垂直移动ing
 */
- (void)zf_panVerticalMovingType:(ZFTipViewType)type withValue:(CGFloat)value;

@end

@interface ZFPlayerView : UIView
/// 视频控制层, 自定义层
@property (nonatomic, strong, readonly) ZFPlayerControlView *playerControlView;
/// 未播放, 封面的View
@property (nonatomic, strong, readonly) ZFCoverControlView  *coverControlView;
/// PlayerViewDelagate 
@property (nonatomic, weak) id<ZFPlayerViewDelagate>        delegate;
/// 播放的模型
@property (nonatomic, strong) ZFPlayerItem                  *playerItem;
///
@property (nonatomic, weak) UIView                          *playerLayerView;
/// 当前的控制器，根据window遍历出来的
@property (nonatomic, weak) UIViewController                *rootVC;
/// playerView所在的父视图
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, assign) CGRect beforeFrame;
@property (nonatomic, assign) CGPoint beforeCenter;
@property (nonatomic, assign) ZFPlayerViewScreenState screenState;

/**
 * playerView初始化
 *
 * @param superview playerView所在的superView
 */
- (void)zf_playerWithView:(UIView *)superview;

- (void)zf_cellPlayerWithViewTag:(NSInteger)viewTag
                      scrollView:(UIScrollView *)scrollView
                       indexPath:(NSIndexPath *)indexPath;
/**
 * 重置playerView
 */
- (void)zf_playerResetPlayerView;

/**
 *  开始准备播放
 */
- (void)zf_startReadyToPlay;

/**
 *  设置横屏或竖屏
 */
- (void)zf_shrinkOrFullScreen:(BOOL)isFull;

/**
 *  播放完了
 */
- (void)zf_playDidEnd;

/**
 *  重新播放
 */
- (void)zf_prepareToPlay;

@end
