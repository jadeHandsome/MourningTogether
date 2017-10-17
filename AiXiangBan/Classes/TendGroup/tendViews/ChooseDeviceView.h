//
//  ChooseDeviceView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ADD_CLICK)(NSDictionary *dic,BOOL isChoose);
@interface ChooseDeviceView : UIView
@property (nonatomic, strong) ADD_CLICK addBlock;
@property (nonatomic, assign) BOOL isChoose;
- (void)setUpWith:(NSDictionary *)dic;
@end
