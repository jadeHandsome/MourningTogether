//
//  RoailView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/15.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RoailView.h"
#import "YHArcSlider.h"
@interface RoailView()

@property (nonatomic, strong) UILabel *label;
@end
@implementation RoailView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}
- (void)setUp {
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 195, 137.5 - 40)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:40];
    self.label.textColor = [UIColor colorWithRed:0 green:188.0/255 blue:210.0/255 alpha:1];
    self.label.text = @"-120";
    [self addSubview:self.label];
    
    YHArcSlider *slder = [[YHArcSlider alloc]initWithFrame:CGRectMake(25, 15, 150, 150)];
    slder.startAngle = M_PI_4 * 3.3;
    slder.circleLineWidth = 17;
    [slder addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    UIColor *greenColor = [UIColor clearColor];
    
    YHSector *sector = [YHSector sectorWithColor:greenColor maxValue:19];
    
    sector.tag = 2;
    
    sector.startValue = 0;
    sector.endValue = 12.7;
    
    slder.markRadius = 10;
    slder.lineWidth = 0;
    slder.sector = sector;
    slder.sectorsRadius = 67;
    [self addSubview:slder];
}
- (void)valueChange:(YHArcSlider *)slder {
    NSLog(@"%.0f",slder.sector.startValue * 240/12.7 - 120);
    //NSLog(@"%f",slder.sector.startValue);
    self.label.text = [NSString stringWithFormat:@"%.0f",slder.sector.startValue * 240/12.7 - 120];
    if (self.block) {
        self.block(slder.sector.startValue * 240/12.7 - 120);
    }
}

//通过角度获得x,y值
- (CGPoint)getPointWithAngle:(CGFloat)angle radius:(CGFloat)r{
    CGFloat y = r*sin(angle*3.14159/180.0);
    CGFloat x = r*cos(angle*3.14159/180.0);
    return CGPointMake(x, y);
}
@end
