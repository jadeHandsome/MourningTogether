//
//  ZFPlayer.h
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
#import "ZFPlayerView.h"
#import "ZFPlayerItem.h"
#import "ZFPlayerControlView.h"
#import "UIViewController+ZFPlayerRotation.h"
#import "UIImageView+ZFCache.h"
#import "UIWindow+CurrentViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ZFAVPlayerManager.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
@class ZFPlayerView;
@protocol ZFPlayerDelegate <NSObject>

@optional

/** 
 * 返回按钮被点击
 */
- (void)zf_playerBackButtonClick;

/** 
 * 控制层封面点击事件的回调
 */
- (void)zf_controlViewTapAction;

/** 
 * 播放完了
 */
- (void)zf_playerDidEndAction;

@end

@interface ZFPlayer : NSObject <ZFPlayerPlayback>

/// 代理
@property (nonatomic, weak) id<ZFPlayerDelegate> delegate;

/// 最底层的父视图
@property (nonatomic, strong, readonly) ZFPlayerView       *playerView;

@property (nonatomic, weak) UIViewController *rootVC;

/**
 * Initialize player
 *
 * @view          the superView
 * @playerItem    the playerItem
 * @delegate the  ZFPlayerDelegate
 */
+ (instancetype)zf_playerWithView:(UIView *)view
                         delegate:(id<ZFPlayerDelegate>)delegate;

- (void)zf_cellPlayerWithViewTag:(NSInteger)viewTag
                      scrollView:(UIScrollView *)scrollView
                       indexPath:(NSIndexPath *)indexPath;

/**
 * According to the video address chose ijkplayer or avplayer
 *
 * @playerItem  the playerItem
 */
- (void)zf_setPlayerItem:(ZFPlayerItem *)playerItem;

/**
 * Set playerType and playerItem
 *
 * @param playerItem the playerItem
 * @param type       the player type
 */
- (void)zf_setPlayerItem:(ZFPlayerItem *)playerItem withType:(ZFPlayerType)type;

/**
 * According to the video address chose ijkplayer or avplayer
 *
 * @param playerItems array of playerItems
 */
- (void)zf_setPlayerItems:(NSArray<ZFPlayerItem *> *)playerItems;

/**
 * Set playerType and playerItem
 *
 * @param playerItems array of playerItems
 * @param type        the player type
 */
- (void)zf_setPlayerItems:(NSArray<ZFPlayerItem *> *)playerItems withType:(ZFPlayerType)type;

/**
 * Replace currentItem with playerItem to play a new video
 *
 * @param playerItem watchrRecordView
 */
- (void)zf_replaceCurrentItemWithPlayerItem:(ZFPlayerItem *)playerItem;

@end
