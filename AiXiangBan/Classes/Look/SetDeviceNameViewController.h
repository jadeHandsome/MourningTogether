//
//  SetDeviceNameViewController.h
//  孝相伴
//
//  Created by MAC on 17/10/10.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^DidSetName)(NSString *);
@interface SetDeviceNameViewController : BaseViewController
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) DidSetName block;
@property (nonatomic, strong) NSString *devicePower;
@end
