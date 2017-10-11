//
//  LookCell.m
//  孝相伴
//
//  Created by MAC on 17/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LookCell.h"

@implementation LookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)setAction:(UIButton *)sender {
    self.block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
