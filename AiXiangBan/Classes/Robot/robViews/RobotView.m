//
//  RobotView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RobotView.h"
@interface RobotView()
@property (nonatomic, strong) NSDictionary *myData;

@end
@implementation RobotView

{
    responseObjectBlock block;
}

- (void)setUpWithDic:(NSDictionary *)dic withClickHandle:(responseObjectBlock)clickHandle {
    if (!dic) {
        return;
    }
    block = clickHandle;
    self.myData = [dic copy];
    UIImageView *headImageView = [[UIImageView alloc]init];
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    headImageView.contentMode = UIViewContentModeCenter;
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = dic[@"name"];
    UILabel *IDLabel = [[UILabel alloc]init];
    [self addSubview:IDLabel];
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.equalTo(nameLabel.mas_height);
    }];
    IDLabel.textColor = LRRGBColor(145, 145, 145);
    IDLabel.text = [NSString stringWithFormat:@"ID：%@",dic[@"ID"]];
    
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
        block(self.myData);
    }
}
@end
