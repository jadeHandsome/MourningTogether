//
//  ZFPlayerItem.h
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
#import "ZFUtilities.h"
@class ZFResolution;

@interface ZFPlayerItem : NSObject

/// 视频标题
@property (nonatomic, copy  ) NSString     *title;
/// 视频URL
@property (nonatomic, strong) NSURL        *videoURL;
/// 视频封面本地图片 */
@property (nonatomic, strong) UIImage      *placeholderImage;
/// 视频封面网络图片url,如果和本地图片同时设置，则忽略本地图片，显示网络图片
@property (nonatomic, copy  ) NSString     *placeholderImageURLString;
/// 视频分辨率(key:分辨率名称，value:播放地址)
@property (nonatomic, copy) NSDictionary   *resolutionDic;

@property (nonatomic, copy) NSArray<ZFResolution *> *resolution;
/// 从xx秒开始播放视频(默认0)
@property (nonatomic, assign) NSInteger    seekTime;
/// 上次播放至xx秒(默认0)
@property (nonatomic, assign) NSInteger    viewTime;
/// 视频的集数
@property (nonatomic, copy)   NSString     *videoId;
/// 当前播放的item的，标记用
@property (nonatomic, assign) BOOL         selected;

//@property (nonatomic, assign) NSInteger     viewTag;
//@property (nonatomic, strong) UIScrollView  *scrollView;
//@property (nonatomic, strong) NSIndexPath   *indexPath;

@end

@interface ZFResolution : NSObject
/// 分辨率的名称
@property (nonatomic, copy) NSString *title;
/// 分辨率的播放url
@property (nonatomic, copy) NSString *url;
/// 当前播放的分辨率视频，标记用
@property (nonatomic, assign) BOOL selected;

@end

@interface ZFPlayerStatusModel : NSObject

/// 是否被用户暂停
@property (nonatomic, assign, getter = isPauseByUser)        BOOL pauseByUser;
/// 播放完了
@property (nonatomic, assign, getter = isPlayDidEnd)         BOOL playDidEnd;
/// 进入后台
@property (nonatomic, assign, getter = isDidEnterBackground) BOOL didEnterBackground;
/// 是否正在拖拽进度条
@property (nonatomic, assign, getter = isDragged)            BOOL dragged;
/// 是否全屏
@property (nonatomic, assign, getter = isFullScreen)         BOOL fullScreen;
/// 正在转屏中
@property (nonatomic, assign, getter = isOrientationAnimating)BOOL orientationAnimating;
/// 否锁定屏幕方向
@property (nonatomic, assign, getter = isLockScreen)         BOOL lockScreen;
/// 是否允许横屏,来控制只有竖屏的状态
@property (nonatomic, assign, getter = isAllowLandscape)     BOOL allowLandscape;
/// status隐藏
@property (nonatomic, assign, getter = isStatusBarHidden)    BOOL statusBarHidden;
/// 分辨率或者选集的view正在显示
@property (nonatomic, assign, getter = isToolViewShow)       BOOL toolViewShow;
/// 是否是小屏状态
@property (nonatomic, assign, getter = isShrink)             BOOL shrink;

@property (nonatomic, assign) ZFPlayerViewType playerViewType;

/** 
 * 单例
 */
+ (instancetype)sharedPlayerStatusModel;

/**
 * 重置状态模型属性 
 */
- (void)playerResetStatusModel;

@end
