//
//  CustomSliderView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/13.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^valueChange)(CGFloat f);
@interface CustomSliderView : UIView
@property (nonatomic, copy) valueChange block;
@property (nonatomic, assign) CGFloat vaule;
- (void)setUpV;

@end
