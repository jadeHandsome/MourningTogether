//
//  ZFFullScreenTransition.h
//  ZFPlayer
//
//  Created by 任子丰 on 2017/8/29.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFPlayerView;

typedef NS_ENUM(NSInteger,ZFTransitionType) {
    ZFTransitionTypePresent = 0,
    ZFTransitionTypeDismiss  = 1
};

@interface ZFFullScreenTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(ZFTransitionType)transitionType playerView:(ZFPlayerView *)playerView;

@end
