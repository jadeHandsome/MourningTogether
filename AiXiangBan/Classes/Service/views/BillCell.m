//
//  BillCell.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BillCell.h"

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, SIZEWIDTH - 20, 80);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
