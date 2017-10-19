//
//  AlarmBtnView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AlarmBtnView.h"

@implementation AlarmBtnView

- (IBAction)btnClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}


@end
