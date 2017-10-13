//
//  CallCardCell.m
//  孝相伴
//
//  Created by MAC on 17/10/13.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CallCardCell.h"

@implementation CallCardCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)openOrClose:(UIButton *)sender {
    self.switchBlock();
}
- (IBAction)goDetail:(UITapGestureRecognizer *)sender {
    self.detailBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
