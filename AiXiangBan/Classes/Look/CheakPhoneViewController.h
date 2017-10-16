//
//  CheakPhoneViewController.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"

@interface CheakPhoneViewController : BaseViewController
@property (nonatomic, strong) NSString *deviceSerialNo;
@property (nonatomic, strong) NSString *deviceVerifyCode;
@property (nonatomic, assign) NSInteger deviceType;
@end
