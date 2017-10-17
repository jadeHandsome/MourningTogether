//
//  AddTendView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TendOldView.h"
typedef void(^ADD_CLICKWITH)(NSInteger tag,BOOL isAdd);
@interface AddTendView : UIView
@property (nonatomic, copy) ADD_CLICKWITH block;
@property (nonatomic, copy) BTNS_CLICK btnBlock;
- (void)setAddTendWith:(NSDictionary *)tendDic;
@end
