//
//  WifiConfigViewController.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/11/28.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"

@interface WifiConfigViewController : BaseViewController
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSString *deviceSerialNo;
@property (nonatomic, strong) NSString *deviceVerifyCode;
@property (nonatomic) BOOL isAddDeviceSuccessed;
@end
