//
//  ZFPlayerView.m
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

#import "ZFPlayerView.h"
#import "ZFFullScreenViewController.h"
#import "ZFPlayer.h"
#import "ZFFullScreenTransition.h"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, ZFPanDirection){
    ZFPanDirectionHorizontalMoved, // 横向移动
    ZFPanDirectionVerticalMoved    // 纵向移动
};

@interface ZFPlayerView () <UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate,UIViewControllerTransitioningDelegate,UIScrollViewDelegate> {
    /// 单击
    UITapGestureRecognizer *_singleTap;
    /// 双击
    UITapGestureRecognizer *_doubleTap;
    /// 滑动
    UIPanGestureRecognizer *_panRecognizer;
    /// 小屏拖动窗口的手势
    UIPanGestureRecognizer *_shrinkPanGesture;
    /// 记录scrollView横屏之前的contentoffset
    CGPoint                _contentOffSet;
    /// 定义一个实例变量，保存枚举值
    ZFPanDirection         _panDirection;
    ///
    NSInteger              _viewTag;
    ///
    NSIndexPath            *_indexPath;
    /// 声音slider,获取系统音量
    UISlider               *_volumeViewSlider;
}

/// 控制，互动层
@property (nonatomic, strong) ZFPlayerControlView *playerControlView;
/// 未播放, 封面的View
@property (nonatomic, strong) ZFCoverControlView *coverControlView;
/// 是否在调节音量
@property (nonatomic, assign) BOOL isVolume;
/// 未播放之前显示的封面图
@property (nonatomic, strong) UIImageView *coverView;
/// 全屏的控制器
@property (nonatomic, weak) ZFFullScreenViewController *fullScrrenVC;
/// 列表view
@property (nonatomic, strong) UIScrollView *scrollView;
/// 小屏的父视图
@property (nonatomic, strong) UIView *shrinkView;
/// 小屏的frme
@property (nonatomic, assign) CGPoint shrinkCenter;
/// 竖屏原始的frame
@property (nonatomic, assign) CGRect originRect;

@end

@implementation ZFPlayerView

@synthesize shrinkCenter = _shrinkCenter;

#pragma mark - override

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        [self configureVolume];
    }
    return self;
}

- (void)dealloc {
    [self.shrinkView removeFromSuperview];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addSubviewWithCons {
    /// 转屏通知
    [self listeningRotating];
    [self.parentView addSubview:self];
    [self addSubview:self.playerControlView];
    [self insertSubview:self.coverView belowSubview:self.playerControlView];
    self.coverView.image = ZFPlayer_Image(@"ZFPlayer_loading_bgView");
    [self addSubview:self.coverControlView]; // 最后添加, 放在最外面
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (ZFPlayer_Shared.isFullScreen) {
        CGFloat width = MAX(ZFPlayer_ScreenWidth, ZFPlayer_ScreenHeight);
        CGFloat height = MIN(ZFPlayer_ScreenWidth, ZFPlayer_ScreenHeight);
        self.frame = CGRectMake(0, 0, width, height);
    } else {
        if (self.superview == self.parentView) {
            self.frame = self.parentView.bounds;
        } else {
//            self.frame = self.originRect;
        }
    }
    self.coverControlView.frame = self.bounds;
    self.playerControlView.frame = self.bounds;
    self.coverView.frame = self.bounds;
    self.playerLayerView.frame = self.bounds;
}

#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (ZFPlayer_Shared.playDidEnd)  return;
        if (ZFPlayer_Shared.isShrink && !ZFPlayer_Shared.isFullScreen) {
            [self enterFullScreen:UIInterfaceOrientationLandscapeRight];
        } else {
            if (self.playerControlView.isShowing) {
                [self.playerControlView zf_hideControl];
            } else {
                [self.playerControlView zf_showControl];
            }
        }
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (ZFPlayer_Shared.playDidEnd) { return;  }
    // 显示控制层
    [self.playerControlView zf_showControl];
    
    if ([self.delegate respondsToSelector:@selector(zf_doubleTapAction)]) {
        [self.delegate zf_doubleTapAction];
    }
}

/**
 *  pan手势添加播放进度、亮度、声音
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    // 根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                _panDirection = ZFPanDirectionHorizontalMoved;
                if ([self.delegate respondsToSelector:@selector(zf_panHorizontalBeginMoved)]) {
                    [self.delegate zf_panHorizontalBeginMoved];
                }
            }
            else if (x < y){ // 垂直移动
                _panDirection = ZFPanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (_panDirection) {
                case ZFPanDirectionHorizontalMoved:{
                    if ([self.delegate respondsToSelector:@selector(zf_panHorizontalMoving:)]) {
                        [self.delegate zf_panHorizontalMoving:veloctyPoint.x];
                    }
                    break;
                }
                case ZFPanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (_panDirection) {
                case ZFPanDirectionHorizontalMoved:{
                    if ([self.delegate respondsToSelector:@selector(zf_panHorizontalEndMoved)]) {
                        [self.delegate zf_panHorizontalEndMoved];
                    }
                    break;
                }
                case ZFPanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)shrikPanAction:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:[UIApplication sharedApplication].keyWindow];
    ZFPlayerView *view = (ZFPlayerView *)gesture.view;
    const CGFloat width = view.frame.size.width;
    const CGFloat height = view.frame.size.height;
    const CGFloat distance = 10;  // 离四周的最小边距
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        // x轴的的移动
        if (point.x <= distance + width / 2) {
            point.x = distance + width / 2;
        } else if (point.x >= ZFPlayer_ScreenWidth - width / 2 - distance) {
            point.x = ZFPlayer_ScreenWidth - width / 2 - distance;
        }
        // y轴的移动
        if (point.y <= distance + height / 2) {
            point.y = distance + height / 2;
        } else if (point.y >= ZFPlayer_ScreenHeight - height / 2 - distance) {
            point.y = ZFPlayer_ScreenHeight - height / 2 - distance;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.shrinkCenter = point;
        }];
        
    } else {
        self.shrinkCenter = point;
    }
}

- (void)enterFullScreen:(UIInterfaceOrientation)orientation {
    if (ZFPlayer_Shared.fullScreen) return;
    
    ZFPlayer_Shared.fullScreen = YES;

    self.screenState = ZFPlayerViewScreenStateAnimating;
    self.originRect = [[UIApplication sharedApplication].keyWindow convertRect:self.parentView.frame fromView:self.parentView.superview];
    if (ZFPlayer_Shared.playerViewType != ZFPlayerViewTypeNormal) {
        _contentOffSet = _scrollView.contentOffset;
    }
    self.beforeFrame = self.originRect;
    self.beforeCenter = self.parentView.center;

    ZFFullScreenViewController *fullScrrenVC = [[ZFFullScreenViewController alloc] init];
    fullScrrenVC.orientation = orientation;
    fullScrrenVC.playerView = self;
    fullScrrenVC.modalPresentationStyle = UIModalPresentationFullScreen;
    fullScrrenVC.transitioningDelegate = self;
    __weak typeof(self) weakSelf = self;
    
    
    // 显示制栏, 屏幕切换时就显示
    [self.playerControlView zf_hideControl];
    [self.rootVC presentViewController:fullScrrenVC animated:YES completion:^{
        weakSelf.screenState = ZFPlayerViewScreenStateFullScreen;
    }];
    self.fullScrrenVC = fullScrrenVC;
}

- (void)exitFullScreen {
    __weak typeof(self) weakSelf = self;
    self.screenState = ZFPlayerViewScreenStateAnimating;
    ZFPlayer_Shared.fullScreen = NO;
    // 显示制栏, 屏幕切换时就显示
    [self.playerControlView zf_hideControl];
    
    [self.fullScrrenVC dismissViewControllerAnimated:YES completion:^{
        weakSelf.screenState = ZFPlayerViewScreenStateSmall;
        [weakSelf.parentView addSubview:self];
        [weakSelf setNeedsLayout];
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark - Private method

/**
 *  创建手势
 */
- (void)createGesture {
    if (_singleTap || _doubleTap || _panRecognizer) {
        [self removeGestureRecognizer:_singleTap];
        [self removeGestureRecognizer:_doubleTap];
        [self removeGestureRecognizer:_panRecognizer];
    }
    
    // 单击
    _singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    _singleTap.delegate                = self;
    _singleTap.numberOfTouchesRequired = 1; //手指数
    _singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:_singleTap];
    
    // 双击(播放/暂停)
    _doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    _doubleTap.delegate                = self;
    _doubleTap.numberOfTouchesRequired = 1; //手指数
    _doubleTap.numberOfTapsRequired    = 2;
    
    [self addGestureRecognizer:_doubleTap];
    
    // 解决点击当前view时候响应其他控件事件
    [_singleTap setDelaysTouchesBegan:YES];
    [_doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [_singleTap requireGestureRecognizerToFail:_doubleTap];
    
    // 添加平移手势，用来控制音量、亮度、快进快退
    _panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    _panRecognizer.delegate = self;
    [_panRecognizer setMaximumNumberOfTouches:1];
    [_panRecognizer setDelaysTouchesBegan:YES];
    [_panRecognizer setDelaysTouchesEnded:YES];
    [_panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:_panRecognizer];
    
    if (ZFPlayer_Shared.playerViewType != ZFPlayerViewTypeNormal) {
        _shrinkPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(shrikPanAction:)];
        _shrinkPanGesture.delegate = self;
        [self addGestureRecognizer:_shrinkPanGesture];
    }
}

/**
 *  获取系统音量
 */
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.center = CGPointMake(-10000, 0);
    [self addSubview:volumeView];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
    ];
}

- (void)onDeviceOrientationChange {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown) { return; }
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
        }
            break;
        case UIInterfaceOrientationPortrait:{
            [self exitFullScreen];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            [self enterFullScreen:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            [self enterFullScreen:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
}

- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
    if (self.isVolume) {
        _volumeViewSlider.value -= value / 10000;
        if ([self.delegate respondsToSelector:@selector(zf_panVerticalMovingType:withValue:)]) {
            [self.delegate zf_panVerticalMovingType:ZFTipViewTypeVolume withValue:_volumeViewSlider.value];
        }
    } else {
        [UIScreen mainScreen].brightness -= value / 10000;
        if ([self.delegate respondsToSelector:@selector(zf_panVerticalMovingType:withValue:)]) {
            [self.delegate zf_panVerticalMovingType:ZFTipViewTypeBrightness withValue:[UIScreen mainScreen].brightness];
        }
    }
}

- (void)handleScrollOffsetWithDict:(NSDictionary*)dict {
    if ([_scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)_scrollView;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:_indexPath];
        NSArray *visableCells = tableView.visibleCells;
        if ([visableCells containsObject:cell]) {
            // 在显示中
            [self updatePlayerViewToCell];
        } else {
            // 在底部
            [self updatePlayerViewToBottom];
        }
    } else if ([_scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)_scrollView;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:_indexPath];
        if ( [collectionView.visibleCells containsObject:cell]) {
            // 在显示中
            [self updatePlayerViewToCell];
        } else {
            // 在底部
            [self updatePlayerViewToBottom];
        }
    }
}

- (void)updatePlayerViewToCell {
    //    if (!ZFPlayer_Shared.shrink) return;
    ZFPlayer_Shared.shrink = NO;
    UIView *parentView;
    if ([_scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)_scrollView;
        UITableViewCell *cell  = [tableView cellForRowAtIndexPath:_indexPath];
        parentView             = [cell.contentView viewWithTag:_viewTag];
        ZFPlayer_Shared.playerViewType = ZFPlayerViewTypeTableView;
        
    } else if ([_scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)_scrollView;
        UICollectionViewCell *cell       = [collectionView cellForItemAtIndexPath:_indexPath];
        parentView                       = [cell.contentView viewWithTag:_viewTag];
        ZFPlayer_Shared.playerViewType   = ZFPlayerViewTypeCollectionView;
    }
    self.parentView = parentView;
    [self.shrinkView removeFromSuperview];
    [self.playerControlView zf_showControl];
    
}

- (void)updatePlayerViewToBottom {
    if (ZFPlayer_Shared.shrink) return;
    
    ZFPlayer_Shared.shrink = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.shrinkView];
    
    self.shrinkView.center = self.shrinkCenter;
    self.parentView = self.shrinkView;
    [self.playerControlView zf_hideControl];
}

#pragma mark - Public method

- (void)zf_playerWithView:(UIView *)superview {
    self.parentView = superview;
    [self addSubviewWithCons];
    ZFPlayer_Shared.playerViewType = ZFPlayerViewTypeNormal;
}

- (void)zf_cellPlayerWithViewTag:(NSInteger)viewTag
                      scrollView:(UIScrollView *)scrollView
                       indexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _viewTag = viewTag;
    self.scrollView = scrollView;
    [self updatePlayerViewToCell];
    [self addSubviewWithCons];
}

- (void)setPlayerLayerView:(UIView *)playerLayerView {
    if (!playerLayerView) return;
    _playerLayerView = playerLayerView;
    [self insertSubview:playerLayerView belowSubview:self.playerControlView];
    if (self.playerItem.placeholderImageURLString) {
        [self.coverView setImageWithURLString:self.playerItem.placeholderImageURLString placeholder:self.playerItem.placeholderImage];
    } else {
        self.coverView.image = self.playerItem.placeholderImage;
    }
}

- (void)setParentView:(UIView *)parentView {
    if (!parentView) return;
    _parentView = parentView;
    [parentView addSubview:self];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

/** 
 * 重置playerView 
 */
- (void)zf_playerResetPlayerView {
    self.coverView.hidden = NO;
    [self.playerControlView zf_playerResetControlView];
    self.scrollView = nil;
    [self.shrinkView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)zf_shrinkOrFullScreen:(BOOL)isFull {
    if (isFull) { // 设置全屏
        [self enterFullScreen:UIInterfaceOrientationLandscapeRight];
    } else {
        [self exitFullScreen];
    }
}

/**
 *  播放完成时隐藏控制层
 */
- (void)zf_playDidEnd {
    [self.playerControlView zf_playDidEnd];
}

/**
 *  重新播放
 */
- (void)zf_prepareToPlay {
    // 重置控制层View
    [self.playerControlView zf_playerResetControlView];
    [self.playerControlView zf_showControl];
}

/**
 *  开始准备播放
 */
- (void)zf_startReadyToPlay {
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.coverView.alpha = 1;
    }];
    // 添加手势
    if (!_singleTap || !_doubleTap || !_panRecognizer) {
        [self createGesture];
    }
    // 设置viewTimeView
    [self.playerControlView zf_startReadyToPlay];
}

#pragma mark - getter

- (ZFPlayerControlView *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [[ZFPlayerControlView alloc] init];
    }
    return _playerControlView;
}

- (ZFCoverControlView *)coverControlView {
    if (!_coverControlView) {
        _coverControlView = [[ZFCoverControlView alloc] init];
    }
    return _coverControlView;
}

- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
    }
    return _coverView;
}

//- (UIViewController *)rootVC {
//    if (!_rootVC) {
//        _rootVC = [UIWindow zf_currentViewController];
//    }
//    return _rootVC;
//}
//
//- (ZFFullScreenViewController *)fullScrrenVC {
//    if (!_fullScrrenVC) {
//        _fullScrrenVC = [[ZFFullScreenViewController alloc] init];
//    }
//    return _fullScrrenVC;
//}

#pragma mark - setter

/**
 *  根据tableview的值来添加、移除观察者
 *
 *  @param scrollView scrollView
 */
- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView == scrollView) { return; }
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:kZFPlayerViewContentOffset];
    }
    _scrollView = scrollView;
    if (scrollView) {
        [scrollView addObserver:self forKeyPath:kZFPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (UIView *)shrinkView {
    if (!_shrinkView) {
        _shrinkView = [[UIView alloc] init];
        _shrinkView.backgroundColor = [UIColor clearColor];
    }
    return _shrinkView;
}

- (CGPoint)shrinkCenter {
    if (CGPointEqualToPoint(_shrinkCenter,CGPointZero)) {
        CGFloat margin = 10;
        CGFloat width = ZFPlayer_ScreenWidth / 2 - margin;
        CGFloat height = (self.height / self.width) * width;
        CGFloat x = ZFPlayer_ScreenWidth - width / 2 - margin;
        CGFloat y = ZFPlayer_ScreenHeight - height / 2 - margin - _scrollView.contentInset.bottom;
        _shrinkCenter = CGPointMake(x, y);
        self.shrinkView.size = CGSizeMake(width, height);
    }
    return _shrinkCenter;
}

- (void)setShrinkCenter:(CGPoint)shrinkCenter {
    _shrinkCenter = shrinkCenter;
    self.shrinkView.center = shrinkCenter;
    self.parentView = self.shrinkView;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _scrollView) {
        if ([keyPath isEqualToString:kZFPlayerViewContentOffset]) {
            if (ZFPlayer_Shared.isFullScreen || self.screenState == ZFPlayerViewScreenStateAnimating) { return; }
            // 当tableview滚动时处理playerView的位置
            [self handleScrollOffsetWithDict:change];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ([touch.view isKindOfClass:[UICollectionView class]] || ZFPlayer_Shared.toolViewShow)) {
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ZFPlayer_Shared.lockScreen) {
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (ZFPlayer_Shared.playDidEnd){
            return NO;
        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    if (ZFPlayer_Shared.isShrink) { // 小窗口时候屏蔽的一些手势
        if (gestureRecognizer == _singleTap || (gestureRecognizer == _shrinkPanGesture && !ZFPlayer_Shared.isFullScreen) || (gestureRecognizer == _panRecognizer && ZFPlayer_Shared.isFullScreen)) return YES;
        return NO;
    } else {
        if (gestureRecognizer == _shrinkPanGesture) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [ZFFullScreenTransition transitionWithTransitionType:ZFTransitionTypePresent playerView:self];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [ZFFullScreenTransition transitionWithTransitionType:ZFTransitionTypeDismiss playerView:self];
}
    
@end
