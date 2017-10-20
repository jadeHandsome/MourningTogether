//
//  ZFPlayerItem.m
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

#import "ZFPlayerItem.h"
#import "ZFUtilities.h"
#import "UIWindow+CurrentViewController.h"

@implementation ZFPlayerItem

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = ZFPlayer_Image(@"ZFPlayer_loading_bgView");
    }
    return _placeholderImage;
}

@end

@implementation ZFResolution

@end

@implementation ZFPlayerStatusModel

+ (instancetype)sharedPlayerStatusModel {
    static ZFPlayerStatusModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZFPlayerStatusModel alloc] init];
    });
    return instance;
}

/**
 重置状态模型属性
 */
- (void)playerResetStatusModel {
    self.playDidEnd         = NO;
    self.dragged            = NO;
    self.didEnterBackground = NO;
    self.pauseByUser        = NO;
    self.fullScreen         = NO;
    self.lockScreen         = NO;
    self.allowLandscape     = NO;
    self.statusBarHidden    = NO;
    self.toolViewShow       = NO;
    self.shrink             = NO;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    [[UIWindow zf_currentViewController] setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    [[UIWindow zf_currentViewController] setNeedsStatusBarAppearanceUpdate];
}

@end
