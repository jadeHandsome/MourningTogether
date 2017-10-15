//
//  ControllView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/15.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DIR_CLICK)(NSInteger tag);//1.上 2.下 3.左 4.右 5.暂停
@interface ControllView : UIView
@property (nonatomic, strong) DIR_CLICK block;
@end
