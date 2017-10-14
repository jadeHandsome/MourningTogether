//
//  TendView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TEND_CLICK)(NSDictionary *dic);
@interface TendView : UIView
@property (nonatomic, strong) TEND_CLICK block;
- (void)setTendWithDic:(NSDictionary *)dic;
@end
