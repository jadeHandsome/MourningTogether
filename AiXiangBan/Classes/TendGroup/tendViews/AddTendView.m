//
//  AddTendView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddTendView.h"
#import "TendOldView.h"
#import "ImageCenterButton.h"
@implementation AddTendView

- (void)setAddTendWith:(NSDictionary *)tendDic {
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.height.equalTo(@35);
        make.top.equalTo(self.mas_top);
    }];
    titleLabel.text = tendDic[@"title"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(240, 240, 240);
    if ([tendDic[@"title"] isEqualToString:@"老人"]) {
        UIView *temp = line;
        CGSize size = [UIImage imageNamed:@"云医时代1-100"].size;
        for (int i = 0; i < [tendDic[@"child"] count]; i ++) {
            TendOldView *old = [[TendOldView alloc]init];
            [self addSubview:old];
            [old mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.equalTo(temp.mas_bottom);
                } else {
                    make.top.equalTo(temp.mas_bottom);
                }
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                LRLog(@"%@",@(size.height + 20 + 55 + ([tendDic[@"child"][i][@"equipment"] count]/3 + 1) * 15 + [tendDic[@"child"][i][@"equipment"] count]/3 * 20));
                make.height.equalTo(@(size.height + 20 + 55 + ([tendDic[@"child"][i][@"equipment"] count]/3 + 1) * 15 + [tendDic[@"child"][i][@"equipment"] count]/3 * 20));
            }];
            [old setOldDataWith:tendDic[@"child"][i]];
            UIView *line1 = [[UIView alloc]init];
            [self addSubview:line1];
            [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(old.mas_bottom).with.offset(20);
                make.left.equalTo(self.mas_left).with.offset(10);
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.height.equalTo(@1);
            }];
            line1.backgroundColor = LRRGBColor(240, 240, 240);
            temp = line1;
        }
        UIButton *addBtn = [[UIButton alloc]init];
        [self addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.equalTo(@55);
        }];
        [addBtn setImage:[UIImage imageNamed:@"云医时代1-83"] forState:UIControlStateNormal];
        UIButton *subBtn = [[UIButton alloc]init];
        [self addSubview:subBtn];
        [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom);
            make.left.equalTo(addBtn.mas_right).with.offset(10);
            make.height.equalTo(@55);
        }];
        [subBtn setImage:[UIImage imageNamed:@"云医时代1-84"] forState:UIControlStateNormal];
    } else {
        UIView *temp = self;
        for (int i = 0; i < [tendDic[@"child"] count]; i ++) {
            ImageCenterButton *btn = [[ImageCenterButton alloc]init];
            btn.imageTextSpace = 5;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.imageViewMaxSize = CGSizeMake(SCREEN_WIDTH * 0.2 * 0.5, SCREEN_WIDTH * 0.2 * 0.5);
            [btn setTitle:tendDic[@"child"][i][@"name"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:tendDic[@"child"][i][@"image"]] forState:UIControlStateNormal];
            
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(temp.mas_left).with.offset(10);;
                    
                } else {
                    make.left.equalTo(temp.mas_right).with.offset(10);
                }
                make.width.equalTo(@40);
                make.top.equalTo(line.mas_bottom).with.offset(10);
                make.bottom.equalTo(self.mas_bottom).with.offset(-10);
                
            }];
            temp = btn;
            
        }
        UIButton *addBtn = [[UIButton alloc]init];
        [self addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(10);
            make.left.equalTo(temp.mas_right).with.offset(10);
            make.height.equalTo(@55);
        }];
        [addBtn setImage:[UIImage imageNamed:@"云医时代1-83"] forState:UIControlStateNormal];
        UIButton *subBtn = [[UIButton alloc]init];
        [self addSubview:subBtn];
        [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(10);
            make.left.equalTo(addBtn.mas_right).with.offset(10);
            make.height.equalTo(@55);
        }];
        [subBtn setImage:[UIImage imageNamed:@"云医时代1-84"] forState:UIControlStateNormal];
    }
    LRViewBorderRadius(self, 5, 0, [UIColor clearColor]);
    self.backgroundColor = [UIColor whiteColor];
}

@end
