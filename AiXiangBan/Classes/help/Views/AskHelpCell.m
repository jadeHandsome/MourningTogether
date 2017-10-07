//
//  AskHelpCell.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AskHelpCell.h"

@implementation AskHelpCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, SIZEWIDTH - 20, 45);
}

- (void)changeCell1{
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.hidden = YES;
    self.phoneBtn.hidden = YES;
    self.messageBtn.hidden = YES;
}

- (void)changeCell2{
    self.isChangeCell2 = YES;
    self.phoneBtn.hidden = YES;
    [self.messageBtn setImage:[UIImage imageNamed:@"云医时代1-42"] forState:UIControlStateNormal];
}
- (IBAction)phoneAction:(UIButton *)sender {
    [self.delegate click:@"phone" num:self.numLabel.text];
}
- (IBAction)messageAction:(UIButton *)sender {
    if(self.isChangeCell2){
        [self.delegate click:@"phone" num:self.numLabel.text];
    }
    else{
        [self.delegate click:@"message" num:self.numLabel.text];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
