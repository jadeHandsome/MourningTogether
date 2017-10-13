//
//  ArearViewController.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/11.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^AREA_FINISH)(NSString *result);
@interface ArearViewController : BaseViewController
@property (nonatomic, strong) NSDictionary *myData;
@property (nonatomic, strong) NSString *resultStr;
@property (nonatomic, strong) AREA_FINISH block;
@end
