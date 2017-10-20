//
//  ZFCoverControlView.m
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

#import "ZFCoverControlView.h"
#import "ZFPlayer.h"

@interface ZFCoverControlView ()
/** 背景图片 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation ZFCoverControlView

- (instancetype)init {
    if (self = [super init]) {
        // 添加子控件
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.backBtn];
        [self addSubview:self.playBtn];
        
        // 添加子控件的约束
        self.backgroundColor = [UIColor blackColor];
        [self makeSubViewsAction];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = min_view_h;
    self.backgroundImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 5;
    min_y = 2;
    min_w = 52;
    min_h = 42;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = 75;
    min_h = 75;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.backBtn.center = self.center;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn addTarget:self action:@selector(backgroundImageViewTapAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Action

- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_backButtonClick)]) {
        [self.delegate zf_backButtonClick];
    }
}

- (void)backgroundImageViewTapAction {
    if ([self.delegate respondsToSelector:@selector(zf_coverViewPlayButtonClick)]) {
        [self.delegate zf_coverViewPlayButtonClick];
    }
}

#pragma mark - Public method

/** 更新封面图片 */
- (void)zf_coverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    // 设置网络占位图片
    if (urlString) {
        [self.backgroundImageView setImageWithURLString:urlString placeholder:placeholderImage];
    } else {
        self.backgroundImageView.image = placeholderImage;
    }
}

#pragma mark - getter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = ZFPlayer_Image(@"ZFPlayer_loading_bgView");
    }
    return _backgroundImageView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:ZFPlayer_Image(@"ZFPlayer_play_btn") forState:UIControlStateNormal];
    }
    return _playBtn;
}

@end
