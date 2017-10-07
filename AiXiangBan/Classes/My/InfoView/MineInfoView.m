//
//  MineInfoView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "MineInfoView.h"

@implementation MineInfoView
{
    Click_handle block;
}
- (void)setUpWithDic:(NSDictionary *)dic withClickHandle:(void (^)(void))clickHandle{
    block = clickHandle;
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    titleLabel.text = dic[@"title"];
    titleLabel.textColor = LRRGBColor(145, 145, 145);
    titleLabel.font = [UIFont systemFontOfSize:14];
    //添加右箭头
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"云医时代-23"]];
    [self addSubview:rightImageView];
    rightImageView.contentMode = UIViewContentModeCenter;
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@50);
    }];
    
    if ([dic[@"isImage"] integerValue]) {
        
        UIImageView *headImageView = [[UIImageView alloc]init];
        [self addSubview:headImageView];
        LRViewBorderRadius(headImageView, 20, 0, [UIColor clearColor]);
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImageView.mas_left).with.offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@40);
            make.width.equalTo(@40);
        }];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"right"]] placeholderImage:_zhanweiImageData];
    } else {
        UILabel *rightLabel = [[UILabel alloc]init];
        [self addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImageView.mas_left).with.offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        rightLabel.textColor = [UIColor blackColor];
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.text = dic[@"right"];
    }
    
    UIView *linView = [[UIView alloc]init];
    [self addSubview:linView];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    linView.backgroundColor = LRRGBColor(236, 236, 236);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(click)];
}
- (void)click {
    if (block) {
        block();
    }
}
@end
