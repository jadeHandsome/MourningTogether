//
//  AllDeviceCell.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/16.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AllDeviceCell.h"

@implementation AllDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.block(sender.selected);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
