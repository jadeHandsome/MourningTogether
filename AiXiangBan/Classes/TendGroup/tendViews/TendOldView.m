//
//  TendOldView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TendOldView.h"

@implementation TendOldView

- (void)setOldDataWith:(NSDictionary *)dic {
    UIImageView *headImage = [[UIImageView alloc]init];
    [self addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@55);
        make.height.equalTo(@55);
    }];
    [headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"oldDic"][@"headImgUrl"]] placeholderImage:_zhanweiImageData];
    UIView *temp = headImage;
    
    UILabel *oldLabel = [[UILabel alloc]init];
    [self addSubview:oldLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(temp.mas_right);
        
        make.centerY.equalTo(temp.mas_centerY);
    }];
    oldLabel.text = dic[@"oldDic"][@"familyElderName"];
    oldLabel.textColor = [UIColor blackColor];
    oldLabel.font = [UIFont systemFontOfSize:16];
    temp = self;
    UIView *tempEq = headImage;
    for (int i = 0; i < [dic[@"equipment"] count]; i ++) {
        UIView *subView = [[UIView alloc]init];
        [self addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i % 3 == 0) {
                make.left.equalTo(self.mas_left);
            } else {
                make.left.equalTo(temp.mas_right);
            }
            
            make.height.equalTo(@15);
            if (tempEq == headImage) {
                make.top.equalTo(tempEq.mas_bottom).with.offset(20);
            } else {
               make.top.equalTo(tempEq.mas_bottom).with.offset(20);
            }
            
            make.width.equalTo(@(SCREEN_WIDTH * 0.3333));
        }];
        UIImageView *eqImageView = [[UIImageView alloc]init];
        [subView addSubview:eqImageView];
        [eqImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(subView.mas_left).with.offset(10);
            make.centerY.equalTo(subView.mas_centerY);
            
        }];
        eqImageView.image = [UIImage imageNamed:dic[@"equipment"][i][@"eqImage"]];
        UILabel *eqLabel = [[UILabel alloc]init];
        [subView addSubview:eqLabel];
        [eqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(eqImageView.mas_right).with.offset(10);
            make.centerY.equalTo(subView.mas_centerY);
        }];
        eqLabel.textColor = LRRGBColor(136, 136, 136);
        eqLabel.font = [UIFont systemFontOfSize:14];
        eqLabel.text = dic[@"equipment"][i][@"eqName"];
        if (i % 3 == 2) {
            tempEq = subView;
        }
        temp = subView;
    }
    UIButton *moreEq = [[UIButton alloc]init];
    [self addSubview:moreEq];
    [moreEq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(10);
        
    }];
    [moreEq setTitleColor:LRRGBColor(200, 200, 200) forState:UIControlStateNormal];
    [moreEq setTitle:@" 更多设备" forState:UIControlStateNormal];
    [moreEq setImage:[UIImage imageNamed:@"云医时代1-100"] forState:UIControlStateNormal];
    
}

@end
