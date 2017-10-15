//
//  RoailView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/15.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ROID_CHAGE)(CGFloat f);
@interface RoailView : UIView
@property (nonatomic, strong) ROID_CHAGE block;
@end
