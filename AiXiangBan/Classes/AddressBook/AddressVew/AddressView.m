//
//  AddressView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddressView.h"
@interface AddressView()
@property (nonatomic, strong) NSDictionary *myData;
@property (nonatomic, strong) UIButton *seleectBtn;
@end
@implementation AddressView
{
    responseObjectBlock block;
}
- (void)setUpWithDic:(NSDictionary *)dic withClickHandle:(responseObjectBlock)clickHandle {
    if (!dic) {
        return;
    }
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    block = clickHandle;
    self.myData = [dic copy];
    UIImageView *headImageView = [[UIImageView alloc]init];
    [self addSubview:headImageView];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"headImgUrl"]] placeholderImage:_zhanweiImageData];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.clipsToBounds = YES;
    LRViewBorderRadius(headImageView, 20, 10, [UIColor clearColor]);
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top);
    }];
    nameLabel.textColor = [UIColor blackColor];
    if (dic[@"otherName"]) {
        nameLabel.text = dic[@"otherName"];
    } else if (dic[@"elderName"]) {
        nameLabel.text = dic[@"elderName"];
    } else if (dic[@"familyOtherName"]) {
        nameLabel.text = dic[@"familyOtherName"];
    } else if (dic[@"familyElderName"]) {
        nameLabel.text = dic[@"familyElderName"];
    }
    
    UILabel *IDLabel = [[UILabel alloc]init];
    [self addSubview:IDLabel];
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.equalTo(nameLabel.mas_height);
    }];
    if (self.userInteractionEnabled) {
        IDLabel.textColor = LRRGBColor(145, 145, 145);
        nameLabel.textColor = [UIColor blackColor];
    } else {
        IDLabel.textColor = LRRGBColor(200, 200, 200);
        nameLabel.textColor = LRRGBColor(145, 145, 145);
    }
    
    IDLabel.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    
    UIView *linView = [[UIView alloc]init];
    [self addSubview:linView];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    linView.backgroundColor = LRRGBColor(236, 236, 236);
    
    UIButton *selectBtn = [[UIButton alloc]init];
    _seleectBtn = selectBtn;
    [self addSubview:selectBtn];
    selectBtn.hidden = YES;
    selectBtn.userInteractionEnabled = NO;
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [selectBtn setImage:[UIImage imageNamed:@"云医时代1-10"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"云医时代1-3"] forState:UIControlStateDisabled];
    [selectBtn setImage:[UIImage imageNamed:@"云医时代1-97"] forState:UIControlStateSelected];
    if (self.isAdd) {
        selectBtn.hidden = NO;
        if (self.isChoose) {
            self.seleectBtn.enabled = NO;
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(click)];
    if (!self.isAdd) {
        UILabel *statuLabel = [[UILabel alloc]init];
        [self addSubview:statuLabel];
        [statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        statuLabel.textColor = ColorRgbValue(0x1cb9cf);
        statuLabel.text = @"未验证";
        if (dic[@"valid"]) {
            //if ([dic[@"valid"] integerValue] == 0) {
            
            if ([dic[@"status"] hasPrefix:@"0"]) {
                statuLabel.text = [dic[@"status"] substringFromIndex:2];
            } else if ([dic[@"status"] hasPrefix:@"1"]) {
                UIButton *btn = [[UIButton alloc]init];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@50);
                    make.height.equalTo(@30);
                    make.right.equalTo(self.mas_right).with.offset(-10);
                    make.centerY.equalTo(self.mas_centerY);
                }];
                [btn addTarget:self action:@selector(gotoSure:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = ColorRgbValue(0x1cb9cf);
                [btn setTitle:[dic[@"status"] substringFromIndex:2] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                LRViewBorderRadius(btn, 5, 0, [UIColor clearColor]);
            } else {
                statuLabel.text = @"";
            }
            
        } else {
            statuLabel.hidden = YES;
        }
    }
    
    
}
- (void)gotoSure:(UIButton *)sender {
    //确认
    if (self.ecBlick) {
        self.ecBlick(self.myData);
    }
    
}
- (void)click {
    if (self.isAdd ) {
        if (!self.isChoose) {
            self.seleectBtn.selected = !self.seleectBtn.selected;
            if (self.addBlock) {
                self.addBlock(self.myData,self.seleectBtn.selected);
            }
        }
        
        
    } else {
         if (block) {
            block(self.myData);
          }
        
    }
}

@end
