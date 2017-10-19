//
//  AlarmView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ALARM_CLICK)(NSDictionary *dic);
@interface AlarmView : UIView
@property (nonatomic, strong) ALARM_CLICK block;
- (void)setUpWith:(NSDictionary *)dic;
@end
