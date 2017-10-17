//
//  ChooseDeviceView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ChooseDeviceView.h"
@interface ChooseDeviceView()
@property (nonatomic, strong) UIButton *seleectBtn;
@property (nonatomic, strong) NSDictionary *myData;
@end
@implementation ChooseDeviceView

- (void)setUpWith:(NSDictionary *)dic {
    self.myData = [dic copy];
    UIImageView *deviceImageView = [[UIImageView alloc]init];
    [self addSubview:deviceImageView];
    deviceImageView.image = [UIImage imageNamed:dic[@"eqImage"]];
    [deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@40);
    }];
    
    deviceImageView.contentMode = UIViewContentModeCenter;
    UILabel *nameLabel = [[UILabel alloc]init];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceImageView.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    nameLabel.textColor = LRRGBColor(150, 150, 150);
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = dic[@"eqName"];
    
    UIButton *selectBtn = [[UIButton alloc]init];
    _seleectBtn = selectBtn;
    [self addSubview:selectBtn];
    selectBtn.userInteractionEnabled = NO;
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [selectBtn setImage:[UIImage imageNamed:@"云医时代1-10"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"云医时代1-3"] forState:UIControlStateDisabled];
    [selectBtn setImage:[UIImage imageNamed:@"云医时代1-97"] forState:UIControlStateSelected];
    
    if (self.isChoose) {
        [selectBtn setSelected:YES];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(click)];
}
- (void)click {
  
    
    self.seleectBtn.selected = !self.seleectBtn.selected;
    if (self.addBlock) {
        self.addBlock(self.myData,self.seleectBtn.selected);
    }
    
        
        
    
}

@end
