//
//  AddResultViewController.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/11/27.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"

@interface AddResultViewController : BaseViewController
@property (nonatomic, strong) NSString *deviceSerialNo;
@property (nonatomic, strong) NSString *deviceVerifyCode;
@property (nonatomic, assign) BOOL needConfigWifi;
@end
