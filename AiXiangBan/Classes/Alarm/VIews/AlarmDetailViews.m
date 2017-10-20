//
//  AlarmDetailView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AlarmDetailViews.h"
@interface AlarmDetailViews()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end
@implementation AlarmDetailViews

- (void)awakeFromNib {
    [super awakeFromNib];
    LRViewBorderRadius(self.headImageView, 25, 0, [UIColor clearColor]);
}
- (void)setUpWithDic:(NSDictionary *)dic {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"contactHeadUrl"]] placeholderImage:_zhanweiImageData];
    
    NSString *status = @"";
    switch ([dic[@"status"] integerValue]) {
        case 1:
        {
            status = @"未处理";
        }
            break;
        case 2:
        {
            status = @"处理中";
        }
            break;
        case 3:
        {
            status = @"扩散通知";
        }
            break;
        case 4:
        {
            status = @"解除";
        }
            break;
        case 5:
        {
            status = @"拨打电话";
        }
            break;
            
        default:
            break;
    }
    
    self.statuLabel.text = [dic[@"name"] stringByAppendingString:status];
}
@end
