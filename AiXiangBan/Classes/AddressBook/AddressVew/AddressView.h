//
//  AddressView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ADD_CLICK)(NSDictionary *dic,BOOL isChoose);
typedef void(^ECCEPT)(NSDictionary *dic);
@interface AddressView : UIView
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic, copy) ADD_CLICK addBlock;
@property (nonatomic, strong) ECCEPT ecBlick;

- (void)setUpWithDic:(NSDictionary *)dic withClickHandle:(responseObjectBlock)clickHandle;//设置信息的方法
@end
