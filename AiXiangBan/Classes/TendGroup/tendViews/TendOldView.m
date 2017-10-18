//
//  TendOldView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TendOldView.h"

@interface TendOldView()
@property (nonatomic, strong) NSString *elderId;

@property (nonatomic, strong) NSDictionary *myData;
@end
@implementation TendOldView

- (void)setOldDataWith:(NSDictionary *)dic {
    self.myData = [dic copy];
    UIImageView *headImage = [[UIImageView alloc]init];
    [self addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(7.5);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"oldDic"][@"headImgUrl"]] placeholderImage:_zhanweiImageData];
    LRViewBorderRadius(headImage, 20, 0, [UIColor clearColor]);
    UIView *temp = headImage;
    
    UILabel *oldLabel = [[UILabel alloc]init];
    [self addSubview:oldLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(temp.mas_right).with.offset(10);
        
        make.centerY.equalTo(temp.mas_centerY);
    }];
    oldLabel.text = dic[@"oldDic"][@"familyElderName"];
    self.elderId = dic[@"oldDic"][@"familyElderId"];
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
                make.top.equalTo(tempEq.mas_bottom).with.offset(27.5);
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
        if ([dic[@"equipment"][i][@"eqName"] isEqualToString:@"位置"]) {
            subView.tag = 100;
        } else if ([dic[@"equipment"][i][@"eqName"] isEqualToString:@"看看"]) {
            subView.tag = 200;
        } else if ([dic[@"equipment"][i][@"eqName"] isEqualToString:@"机器人"]) {
            subView.tag = 300;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [subView addGestureRecognizer:tap];
        temp = subView;
        
    }
    UIButton *moreEq = [[UIButton alloc]init];
    [self addSubview:moreEq];
    [moreEq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(10);
        
    }];
    [moreEq addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [moreEq setTitleColor:LRRGBColor(200, 200, 200) forState:UIControlStateNormal];
    [moreEq setTitle:@" 更多设备" forState:UIControlStateNormal];
    [moreEq setImage:[UIImage imageNamed:@"云医时代1-100"] forState:UIControlStateNormal];
    
}
- (void)click:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        //添加设备
        if (self.block) {
            self.block(1, self.elderId,false);
        }
    } else {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender ;
        if (tap.view.tag == 100) {
            //位置
            self.block(2, self.elderId,[self.myData[@"hasLoc"] integerValue]);
        } else if (tap.view.tag == 200) {
            //看看
            self.block(3, self.elderId,[self.myData[@"hasLook"] integerValue]);
        } else if (tap.view.tag == 300) {
            //机器人
            self.block(4, self.elderId,[self.myData[@"hasRobot"] integerValue]);
        }
    }
}

@end
