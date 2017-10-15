//
//  ControllView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/15.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ControllView.h"

@implementation ControllView

- (IBAction)click:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}


@end
