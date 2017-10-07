//
//  CallPushView.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/6.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CallPushView.h"
@interface CallPushView()

@end
@implementation CallPushView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, SIZEWIDTH, SIZEHEIGHT);
    [self showAnimation];
}

- (void)showAnimation{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    CABasicAnimation *scall = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scall.fromValue = @0.8;
    scall.toValue = @1.0;
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @0;
    opacity.toValue = @1;
    group.animations = @[scall,opacity];
    [self.centerView.layer addAnimation:group forKey:@"group"];
}

- (IBAction)watchAction:(UITapGestureRecognizer *)sender {
}
- (IBAction)phoneAction:(UITapGestureRecognizer *)sender {
}

@end
