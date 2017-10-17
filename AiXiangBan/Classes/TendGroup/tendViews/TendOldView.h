//
//  TendOldView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BTNS_CLICK)(NSInteger type,NSString *elderId,NSInteger has);
@interface TendOldView : UIView
@property (nonatomic, strong) BTNS_CLICK block;
- (void)setOldDataWith:(NSDictionary *)dic;
@end
