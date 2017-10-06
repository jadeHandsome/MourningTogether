//
//  RegisterViewController.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/5.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,VC_TYPE){
    VC_TYPE_REGISTER = 0,
    VC_TYPE_GORGETPWD,
};
@interface RegisterViewController : BaseViewController

@property (nonatomic, assign) VC_TYPE type;

@end
