//
//  AlarmBtnView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Alaer_btnclick)(NSInteger tag);
@interface AlarmBtnView : UIView
@property (nonatomic, strong) Alaer_btnclick block;
@end
