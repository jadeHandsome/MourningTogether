//
//  DeleteDeviceViewController.h
//  孝相伴
//
//  Created by MAC on 17/10/10.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^DidDeleteBlock)(void);
@interface DeleteDeviceViewController : BaseViewController
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *devicePower;
@property (nonatomic, strong) DidDeleteBlock block;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *deviceSerialNo;
@end
