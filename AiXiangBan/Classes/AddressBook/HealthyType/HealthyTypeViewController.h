//
//  HealthyTypeViewController.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/11.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SAVE_CICK)(NSArray *paramArray);
@interface HealthyTypeViewController : BaseViewController
@property (nonatomic ,copy) SAVE_CICK block;
@end
