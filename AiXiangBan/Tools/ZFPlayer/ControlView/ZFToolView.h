//
//  ZFToolView.h
//  ZFPlayer
//
//  Created by 任子丰 on 17/6/28.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayerItem.h"

@protocol ZFToolViewDelegate <NSObject>

- (void)zf_changeResolution:(ZFResolution *)resolution;

- (void)zf_changeVideo:(ZFPlayerItem *)playerItem;

@end

typedef NS_ENUM(NSInteger,ZFToolViewType) {
    ZFToolViewTypeResolution,   // 切换分辨率
    ZFToolViewTypeVideos        // 选集
};

@interface ZFToolView : UIView
///
@property (nonatomic, copy) NSArray<ZFResolution *> *resolutions;
///
@property (nonatomic, copy) NSArray<ZFPlayerItem *> *playerItems;
////

@property (nonatomic, weak) id<ZFToolViewDelegate> delegate;
//@property (nonatomic, assign) ZFToolViewType type;

- (void)showToolViewWithType:(ZFToolViewType)type;
- (void)hiddenToolView;

@end
