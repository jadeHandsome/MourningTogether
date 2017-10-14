//
//  TendView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TendView.h"
@interface TendView()
@property (nonatomic, strong) NSDictionary *myData;
@end
@implementation TendView

- (void)setTendWithDic:(NSDictionary *)dic {
    if (!dic) {
        return;
    }
    self.myData = [dic copy];
    UIImageView *headImage = [[UIImageView alloc]init];
    [self addSubview:headImage];
    LRViewBorderRadius(headImage, 20, 0, [UIColor clearColor]);
    [headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"old"][0][@"headImgUrl"]] placeholderImage:_zhanweiImageData];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    UIView *temp = headImage;
    for (int i = 0; i < [dic[@"old"] count]; i ++) {
        UILabel *oldLabel = [[UILabel alloc]init];
        [self addSubview:oldLabel];
        [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_right).with.offset(10);
            } else {
                make.left.equalTo(temp.mas_right).with.offset(20);
            }
            make.centerY.equalTo(temp.mas_centerY);
        }];
        oldLabel.text = dic[@"old"][i][@"familyElderName"];
        oldLabel.textColor = [UIColor blackColor];
        oldLabel.font = [UIFont systemFontOfSize:16];
        temp = oldLabel;
    }
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(240, 240, 240);
    
    UIScrollView *bootomScr = [[UIScrollView alloc]init];
    [self addSubview:bootomScr];
    [bootomScr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(line.mas_bottom);
        make.height.equalTo(@40);
        make.right.equalTo(self.mas_right);
    }];
    CGFloat f = 10;
    for (NSDictionary *sdic in dic[@"child"]) {
        NSString *str = sdic[@"familyOtherName"];
       f += [KRBaseTool getNSStringSize:str andViewWight:20000 andFont:15].width + 60;
    }
    bootomScr.contentSize = CGSizeMake(f + 10, 0);
    temp = bootomScr;
    for (int i = 0; i < [dic[@"child"] count]; i ++) {
        UIImageView *childIamge = [[UIImageView alloc]init];
        [bootomScr addSubview:childIamge];
        LRViewBorderRadius(childIamge, 15, 0, [UIColor clearColor]);
        [childIamge sd_setImageWithURL:[NSURL URLWithString:dic[@"child"][i][@"headImgUrl"]] placeholderImage:_zhanweiImageData];
        [childIamge mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_left).with.offset(10);
                
            } else {
                make.left.equalTo(temp.mas_right).with.offset(20);
            }
            make.top.equalTo(line.mas_bottom).with.offset(10);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        UILabel *childLabel = [[UILabel alloc]init];
        childLabel.font = [UIFont systemFontOfSize:15];
        [bootomScr addSubview:childLabel];
        [childLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(childIamge.mas_right).with.offset(10);
            make.centerY.equalTo(childIamge.mas_centerY);
        }];
        childLabel.text = dic[@"child"][i][@"familyOtherName"];
        temp = childLabel;
    }
    LRViewBorderRadius(self, 5, 0, [UIColor clearColor]);
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tendClick)];
    [self addGestureRecognizer:tap];
}
- (void)tendClick {
    if (self.block) {
        self.block(self.myData);
    }
    
}

@end
