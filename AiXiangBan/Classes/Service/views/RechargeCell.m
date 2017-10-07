//
//  RechargeCell.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RechargeCell.h"

@implementation RechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    LRViewBorderRadius(self.container, 7.5, 1, ColorRgbValue(0x989898));
    // Initialization code
}

- (void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    if(isChoose){
        self.numberLabel.textColor = ThemeColor;
        self.detailLabel.textColor = ThemeColor;
        LRViewBorderRadius(self.container, 7.5, 1, ThemeColor);
    }
    else{
        self.numberLabel.textColor = ColorRgbValue(0x989898);
        self.detailLabel.textColor = ColorRgbValue(0x989898);
        LRViewBorderRadius(self.container, 7.5, 1, ColorRgbValue(0x989898));
    }
}

@end
