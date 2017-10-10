//
//  RepareInfoViewController.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SURE_CLICK)(NSString *repareStr);
@interface RepareInfoViewController : BaseViewController
@property (nonatomic, strong) SURE_CLICK block;
@end
