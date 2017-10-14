//
//  ChooseOlderViewController.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/14.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseOlderViewController : BaseViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDictionary *oldData;
@property (nonatomic, assign) BOOL isDelet;

@end
