//
//  HYTimerButton.m
//  HYTimer
//
//  Created by YOUCAI on 2016.
//  Copyright (c) 2016年 YOUCAI. All rights reserved.
//

#import "HYTimerButton.h"

@interface HYTimerButton()
{
    NSTimer *_timer; // 计时器
    NSInteger _time; // 用来倒计时
    __block NSInteger _timeout;
}
@property (nonatomic,strong) NSString *title; // 标题
@property (nonatomic,strong) UIColor *titleColor; // 标题颜色
@property (nonatomic,strong) UIColor *countDownTitleColor; // 倒计时标题颜色，默认为灰色

//点击后的背景颜色设置
@property (nonatomic, strong) UIColor *djTitleColor;


@property (nonatomic,assign) NSInteger countDownTime; // 传递过来的时间 默认时间值
@end

@implementation HYTimerButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title countDownTime:(NSInteger)time
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        self.title = title;
        self.countDownTime = time;
        _time = time;
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:self action:@selector(selfHasBeenSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)initData
{
    self.titleColor = ColorRgbValue(0x55CAC3);
    [self setTitleColor:_titleColor forState:UIControlStateNormal];
    self.countDownTitleColor = [UIColor darkGrayColor];
}
  // 开启计时器
- (void)selfHasBeenSelected
{
//    [self countDownTimeWithNSTimer];
    
//    [self countDownTimeWithGCD];
}
- (void)start
{
    [self countDownTimeWithGCD];
}
- (void)resetTime
{
    _timeout = 0;
    
    [self initData];
}
 // NSTimer 倒计时
- (void)countDownTimeWithNSTimer
{
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethord) userInfo:Nil repeats:YES];
    [self selfHasBeenSelected];
}
 // GCD 倒计时
- (void)countDownTimeWithGCD
{
    _timeout = _time - 1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t gcd_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(gcd_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(gcd_timer, ^{
        if(_timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(gcd_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self setTitle:_title forState: UIControlStateNormal];
                self.userInteractionEnabled = YES;
                self.backgroundColor = ColorRgbValue(0xFFFFFF);
                // _timerButton.center = CGPointMake(_timerButton.center.x, _codeTextFiled.center.y);
                [self setTitleColor:ThemeColor forState:UIControlStateNormal];
            });
        }else{
//       int minutes = timeout / 60;
            
            int seconds = _timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
//      设置界面的按钮显示 根据自己需求设置
//      NSLog(@"____%@",strTime);
                [self setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                [self setTitleColor:self.countDownTitleColor forState:UIControlStateNormal];
                self.backgroundColor = ColorRgbValue(0xFFFFFF);
                self.userInteractionEnabled = NO;
                
            });
            _timeout--;
            
        }
    });
    dispatch_resume(gcd_timer);
}
 // 倒计时方法
- (void)timeFireMethord
{
    if (_time == 1) {
        // 计时失效
        [_timer invalidate];
        // 时间恢复初始值
        _time = _countDownTime;
        [self setTitle:_title forState: UIControlStateNormal];
        [self setTitleColor:_titleColor forState:UIControlStateNormal];
        // 开启交互
        self.enabled = YES;
    } else {
        _time--;
        NSString *str_title = [NSString stringWithFormat:@"%ld秒后重新发送",(long)_time];
        [self setTitle:str_title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        // 关闭交互
        self.enabled = NO;
    }
}
 // 设置标题颜色
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
}
 // 设置倒计时标题颜色
- (void)setCountDownTitleColor:(UIColor *)countDownTitleColor
{
    _countDownTitleColor = countDownTitleColor;
}

- (void)setDjTitleColor:(UIColor *)djTitleColor{
    
    _djTitleColor = djTitleColor;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
