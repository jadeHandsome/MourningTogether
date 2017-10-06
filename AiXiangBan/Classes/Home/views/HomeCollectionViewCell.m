//
//  HomeCollectionViewCell.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.headImage.layer addCircleBoardWithRadius:self.headImage.height / 2 boardColor:nil boardWidth:0];
    [self.headContainer.layer addCircleBoardWithRadius:self.headContainer.height / 2 boardColor:[UIColor whiteColor] boardWidth:2.5];
}

@end
