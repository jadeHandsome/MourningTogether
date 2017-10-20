//
//  AlarmView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AlarmView.h"
@interface AlarmView()
@property (nonatomic, strong) NSDictionary *myData;
@end
@implementation AlarmView

- (void)setUpWith:(NSDictionary *)dic {
    self.myData = [dic copy];
    UIImageView *headImageView = [[UIImageView alloc]init];
    
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(@40);
    }];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"elderHeadUrl"]] placeholderImage:_zhanweiImageData];
    LRViewBorderRadius(headImageView, 20, 0, [UIColor clearColor]);
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = dic[@"name"];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.height.equalTo(@20);
    }];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = LRRGBColor(186, 186, 186);
    UILabel *deviceLabel = [[UILabel alloc]init];
    deviceLabel.font = [UIFont systemFontOfSize:15];
    deviceLabel.textColor = LRRGBColor(186, 186, 186);
    [self addSubview:deviceLabel];
    NSString *type = @"";
    if ([dic[@"deviceType"] integerValue] == 1) {
        type = @"手表";
    } else if ([dic[@"deviceType"] integerValue] == 2) {
        type = @"摄像头";
    } else {
        type = @"机器人";
    }
    deviceLabel.text = [type stringByAppendingFormat:@"  %@",dic[@"deviceName"]];
    [deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.height.equalTo(@20);
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = LRRGBColor(186, 186, 186);
    NSString *year = [dic[@"time"] substringToIndex:4];
    NSString *month = [dic[@"time"] substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [dic[@"time"] substringWithRange:NSMakeRange(6, 2)];
    NSString *hore = [dic[@"time"] substringWithRange:NSMakeRange(8, 2)];
    NSString *minit = [dic[@"time"] substringWithRange:NSMakeRange(10, 2)];
    NSString *second = [dic[@"time"] substringWithRange:NSMakeRange(12, 2)];
    timeLabel.text = [NSString stringWithFormat:@"%@年%@月%@日 %@:%@:%@",year,month,day,hore,minit,second];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    UILabel *statuLabel = [[UILabel alloc]init];
    NSString *statu = @"";
    switch ([dic[@"status"] integerValue]) {
        case 0:
        {
            statu = @"没有老人";
        }
            break;
        case 1:
        {
            statu = @"未处理";
        }
            break;
        case 2:
        {
            statu = @"自动扩散通知";
        }
            break;
            
        case 3:
        {
            statu = @"处理中";
        }
            break;
        case 4:
        {
            statu = @"扩散通知";
        }
            break;
        case 5:
        {
            statu = @"拨打电话";
        }
            break;
        case 6:
        {
            statu = @"解除";
        }
            break;
            
        default:
            break;
    }
    statuLabel.text = statu;
    [self addSubview:statuLabel];
    [statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom);
        make.right.equalTo(self.mas_right).with.offset(-10);
        
    }];
    statuLabel.textColor = ColorRgbValue(0x1cb9cf);
    statuLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
        
    }];
    line.backgroundColor = LRRGBColor(186, 186, 186);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];
}
- (void)click {
    if (self.block) {
        self.block(self.myData);
        
    }
}

@end
