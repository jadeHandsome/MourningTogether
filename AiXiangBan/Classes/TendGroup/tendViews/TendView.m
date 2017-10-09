//
//  TendView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TendView.h"

@implementation TendView

- (void)setTendWithDic:(NSDictionary *)dic {
    UIImageView *headImage = [[UIImageView alloc]init];
    [self addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@55);
        make.height.equalTo(@55);
    }];
    UIView *temp = headImage;
    for (int i = 0; i < [dic[@"old"] count]; i ++) {
        UILabel *oldLabel = [[UILabel alloc]init];
        [self addSubview:oldLabel];
        [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_right);
            } else {
                make.left.equalTo(temp.mas_right).with.offset(20);
            }
            make.centerY.equalTo(temp.mas_centerY);
        }];
        oldLabel.text = dic[@"old"][i];
        oldLabel.textColor = [UIColor blackColor];
        oldLabel.font = [UIFont systemFontOfSize:16];
        temp = oldLabel;
    }
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_bottom);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(240, 240, 240);
    temp = self;
    for (int i = 0; i < [dic[@"child"] count]; i ++) {
        UIImageView *childIamge = [[UIImageView alloc]init];
        [self addSubview:childIamge];
        [childIamge mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_left);
                
            } else {
                make.left.equalTo(temp.mas_right).with.offset(20);
            }
            make.top.equalTo(line.mas_bottom);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        UILabel *childLabel = [[UILabel alloc]init];
        [self addSubview:childLabel];
        [childLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(childIamge.mas_right);
            make.centerY.equalTo(childIamge.mas_centerY);
        }];
        childLabel.text = dic[@"child"][i];
        temp = childLabel;
    }
    LRViewBorderRadius(self, 5, 0, [UIColor clearColor]);
    self.backgroundColor = [UIColor whiteColor];
}

@end
