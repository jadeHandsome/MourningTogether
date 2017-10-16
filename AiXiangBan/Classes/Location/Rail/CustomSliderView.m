//
//  CustomSliderView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/13.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CustomSliderView.h"
@interface CustomSliderView()

@property (weak, nonatomic) IBOutlet UILabel *meterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveCenter;
@property (weak, nonatomic) IBOutlet UIView *moveView;
@property (weak, nonatomic) IBOutlet UIView *sliderView;

@end
@implementation CustomSliderView
{
    BOOL beginSlider;
    CGPoint lastPoint;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    beginSlider = NO;
    LRViewBorderRadius(self.sliderView, 4, 0, [UIColor clearColor]);
    [self setUp];
    
}
- (void)setUp {
    UIView *leftView = [[UIView alloc]init];
    [self.sliderView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.sliderView.mas_top);
        make.bottom.equalTo(self.sliderView.mas_bottom);
        make.right.equalTo(self.moveView.mas_right).with.offset(-100);
    }];
    leftView.backgroundColor = LRRGBColor(29, 185, 207);
    UIView *rightView = [[UIView alloc]init];
    [self.sliderView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.sliderView.mas_top);
        make.bottom.equalTo(self.sliderView.mas_bottom);
        make.left.equalTo(self.moveView.mas_left).with.offset(100);
    }];
    rightView.backgroundColor = LRRGBColor(204, 204, 204);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.moveView.frame, point)) {
        beginSlider = YES;
        lastPoint = point;
    } else {
        beginSlider = NO;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (beginSlider) {
        CGFloat f = point.x - lastPoint.x;
        self.moveCenter.constant += f;
        
        lastPoint = point;
        
        CGFloat meter = (10000 - 500) * (point.x/self.frame.size.width) + 500;
        
        
        if (self.moveCenter.constant < -self.frame.size.width * 0.5) {
            self.moveCenter.constant = -self.frame.size.width * 0.5;
            meter = 500;
        } else if (self.moveCenter.constant > self.frame.size.width * 0.5) {
            self.moveCenter.constant = self.frame.size.width * 0.5;
            meter = 10000;
        }
        self.vaule = meter;
        self.meterLabel.text = [NSString stringWithFormat:@"%.0fM",meter];
        [self layoutIfNeeded];
        if (self.block) {
            self.block(meter);
        }
    }
}
- (void)setVaule:(CGFloat)vaule {
    _vaule = vaule;
    
}
- (void)setUpV {
    self.moveCenter.constant = 0;
    self.meterLabel.text = [NSString stringWithFormat:@"%.0fM",self.vaule];
    CGFloat x = (self.vaule - 500)/9500 * self.frame.size.width;
    CGFloat f = x - self.frame.size.width * 0.5;
    self.moveCenter.constant += f;
    if (self.moveCenter.constant < -self.frame.size.width * 0.5) {
        self.moveCenter.constant = -self.frame.size.width * 0.5;
    } else if (self.moveCenter.constant > self.frame.size.width * 0.5) {
        self.moveCenter.constant = self.frame.size.width * 0.5;
    }
    [self layoutIfNeeded];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
