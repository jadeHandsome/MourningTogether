//
//  ZFFullScreenTransition.m
//  ZFPlayer
//
//  Created by 任子丰 on 2017/8/29.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "ZFFullScreenTransition.h"
#import "ZFPlayerView.h"

@interface ZFFullScreenTransition () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) ZFPlayerView *playerView;
@property (nonatomic, assign) ZFTransitionType transitionType;
@end

@implementation ZFFullScreenTransition

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

+ (instancetype)transitionWithTransitionType:(ZFTransitionType)transitionType playerView:(ZFPlayerView *)playerView {
    ZFFullScreenTransition *transition = [[self alloc] init];
    if (transition) {
        transition.transitionType = transitionType;
        transition.playerView = playerView;
    }
    return transition;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case ZFTransitionTypeDismiss: {
            [self animateDismissTransition:transitionContext];
        }
            break;
        case ZFTransitionTypePresent: {
            [self animatePresentTransition:transitionContext];
        }
            break;
        default:
            break;
    }
}

- (void)animatePresentTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!toView || !toController) { return; }
    
    [[transitionContext containerView] addSubview:toView];
    // 根据屏幕方向的不同选择不同的角度
    toView.transform = [self getTransformRotationAngle];
    [toView addSubview:self.playerView];
    
    // 计算toView的初始位置
    CGFloat height = MIN(ZFPlayer_ScreenWidth, ZFPlayer_ScreenHeight);
    CGRect rect = CGRectMake(self.playerView.parentView.y, height-CGRectGetMaxX(self.playerView.beforeFrame), self.playerView.width, self.playerView.height);
    // 将toView的 位置变为初始位置，准备动画
    toView.frame = rect;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        toView.transform = CGAffineTransformIdentity;
        toView.bounds = [transitionContext containerView].bounds;
        toView.center = [transitionContext containerView].center;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (!fromView || !toView) { return; }
    
    // 计算 fromView的最终位置
    CGPoint finaleCenter = [[transitionContext containerView] convertPoint:self.playerView.beforeCenter fromView:nil];
    
    // 将 toView 插入fromView的下面，否则动画过程中不会显示toView
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
         // 让 fromView 返回playView的初始值
        fromView.transform = CGAffineTransformIdentity;
        fromView.center = finaleCenter;
        fromView.frame = weakSelf.playerView.beforeFrame;
    } completion:^(BOOL finished) {
         // 动画完成后，将playView添加到竖屏界面上
//        weakSelf.playerView.frame = self.playerView.beforeBounds;
//        [weakSelf.playerView.parentView addSubview:self.playerView];
        [fromView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(-M_PI_2);
    }
    return CGAffineTransformIdentity;
}

- (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != 320 || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}

@end
