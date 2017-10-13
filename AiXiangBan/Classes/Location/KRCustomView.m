//
//  KRCustomView.m
//  fitnessDog
//
//  Created by kupurui on 16/11/23.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRCustomView.h"
#import "UIImageView+WebCache.h"
@interface KRCustomView()

@property (weak, nonatomic) IBOutlet UIImageView *backImages;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *headImage;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *addressLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *distansLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation KRCustomView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self.backImages addGestureRecognizer:tap];
    self.tag = 2000;
    [tap addTarget:self action:@selector(click:)];
    
    
}

- (void)click:(UITapGestureRecognizer *)tap; {
    
    NSLog(@"点击了当前的callout -- tag == %ld",tap.view.tag);
    
    return;
}
- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = time;
}
- (void)drawRect:(CGRect)rect {
    
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:_zhanweiImageData];
}
- (void)setDistance:(NSString *)distance {
    _distance = distance;
    CGFloat f = 0;
    NSString *nowStr = nil;
    if ([distance doubleValue] > 1000) {
        f = [distance doubleValue]/1000;
        nowStr = [NSString stringWithFormat:@"%.2lf千米",f];
    } else {
        f = [distance doubleValue];
        nowStr = [NSString stringWithFormat:@"%.2lf米",f];
    }
    
    //self.distanceLabel.text = [NSString stringWithFormat:@"距离：%@",nowStr];
    self.distansLabel.text = [NSString stringWithFormat:@" 精确范围%@",nowStr];
}

- (IBAction)goearBt:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"qipaoBtnClick" object:@{[NSString stringWithFormat:@"%ld",sender.tag]:self.myData}];
}

@end
