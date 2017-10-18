//
//  CommentCell.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/18.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // UI搭建
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.image = [UIImage imageNamed:@"孝相伴-14"];
    self.image = headImage;
    [self addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = ThemeColor;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(headImage.mas_right).offset(10);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.equalTo(headImage.mas_right).offset(10);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = ColorRgbValue(0x333333);
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(70);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
    }];
    
//    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:bottomView];
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentLabel.mas_bottom);
//        make.left.right.bottom.equalTo(self);
//        make.height.mas_equalTo(1);
//    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
