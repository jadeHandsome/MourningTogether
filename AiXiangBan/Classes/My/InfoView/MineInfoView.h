//
//  MineInfoView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Click_handle)(void);
@interface MineInfoView : UIView
- (void)setUpWithDic:(NSDictionary *)dic withClickHandle:(void(^)(void))clickHandle;//设置信息的方法
@end
