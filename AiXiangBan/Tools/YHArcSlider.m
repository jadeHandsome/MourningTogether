//
//  YHArcCircleSlider.m
//  YHArcSlider
//
//  Created by baiwei－mac on 16/4/18.
//  Copyright © 2016年 BWDV. All rights reserved.
//

#import "YHArcSlider.h"

//整个slider需要的信息参数结构体
typedef struct{
    CGPoint circleCenter;
    CGFloat radius;
    
    double fullLine;
    double circleOffset;
    double circleLine;
    double circleEmpty;
    
    double circleOffsetAngle;
    double circleLineAngle;
    double circleEmptyAngle;
    
    CGPoint startMarkerCenter;
    CGPoint endMarkerCenter;
    
    CGFloat startMarkerRadius;
    CGFloat endMarkerRadius;
    
    CGFloat startMarkerFontSize;
    CGFloat endMarkerFontize;
    
    CGFloat startMarkerAlpha;
    CGFloat endMarkerAlpha;
    
} YHSectorDrawingInformation;


@implementation YHArcSlider{
    YHSector *trackingSector;//变化的点
    YHSectorDrawingInformation trackingSectorDrawInf;//变化点的信息
    BOOL trackingSectorStartMarker;
}

#pragma mark - Initializators

- (instancetype)init{
    if(self = [super init]){
        [self setupDefaultConfigurations];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupDefaultConfigurations];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupDefaultConfigurations];
    }
    return self;
}
//初始化
- (void) setupDefaultConfigurations{
    self.sectorsRadius = 45.0;
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = toRadians(270);
    self.markRadius = 20;
    self.circleLineWidth = 20;
    self.lineWidth = 2;
}

#pragma mark - Setters

- (void)setSectorsRadius:(double)sectorsRadius{
    _sectorsRadius = sectorsRadius;
    [self setNeedsDisplay];
}

#pragma mark - Events manipulator
//开始
- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
        YHSector *sector = self.sector;
        YHSectorDrawingInformation drawInf =[self sectorToDrawInf:sector ];
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.endMarkerCenter]){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = NO;
            return YES;
        }
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.startMarkerCenter]){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = YES;
            return YES;
        }
    
    return NO;
}
//持续
- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint ceter = [self multiselectCenter];
    YHPolarCoordinate polar = decartToPolar(ceter, touchPoint);
    
    double correctedAngle;
    if(polar.angle < self.startAngle) correctedAngle = polar.angle + (2 * M_PI - self.startAngle);
    else correctedAngle = polar.angle - self.startAngle;
    
    double procent = correctedAngle / (M_PI * 2);
    
    double newValue = procent * (trackingSector.maxValue - trackingSector.minValue) + trackingSector.minValue;
    
    if(trackingSectorStartMarker){
        if(newValue > trackingSector.startValue){
            double diff = newValue - trackingSector.startValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.startValue = trackingSector.minValue;
                [self valueChangedNotification];
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue >= trackingSector.endValue){
            trackingSector.startValue = trackingSector.endValue;
            [self valueChangedNotification];
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.startValue = newValue;
        [self valueChangedNotification];
    }
    else{
        if(newValue < trackingSector.endValue){
            double diff = trackingSector.endValue - newValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.endValue = trackingSector.maxValue;
                [self valueChangedNotification];
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue <= trackingSector.startValue){
            trackingSector.endValue = trackingSector.startValue;
            [self valueChangedNotification];
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.endValue = newValue;
        [self valueChangedNotification];
    }
    
    [self setNeedsDisplay];
    
    return YES;
}
//结束
- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    trackingSector = nil;
    trackingSectorStartMarker = NO;
}

- (CGPoint) multiselectCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

//判断点击的位置是否是mark内
- (BOOL) touchInCircleWithPoint:(CGPoint)touchPoint circleCenter:(CGPoint)circleCenter{
    YHPolarCoordinate polar = decartToPolar(circleCenter, touchPoint);
    if(polar.radius >= self.markRadius)
        return NO;
    else
        return YES;
}

- (void) valueChangedNotification{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect{
    
        [self drawSector:self.sector];
}

- (void)drawSector:(YHSector *)sector{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, self.circleLineWidth);
    
    UIColor *startCircleColor = sector.color;

    UIColor *markBackcolor = [UIColor whiteColor];
    
    YHSectorDrawingInformation drawInf = [self sectorToDrawInf:sector];
    
    CGFloat x = drawInf.circleCenter.x;
    CGFloat y = drawInf.circleCenter.y;
    CGFloat r = drawInf.radius;
    
    
    //start circle line
    [startCircleColor setStroke];
    
    CGContextAddArc(context, x, y, r, self.startAngle, drawInf.circleOffsetAngle, 0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);

    
    //clearing place for start marker
    CGContextSaveGState(context);
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius - (self.lineWidth/2.0), 0.0, 6.28, 0);
    CGContextClip(context);
    CGContextClearRect(context, self.bounds);
    CGContextRestoreGState(context);
    
    
    //clearing place for end marker
    CGContextSaveGState(context);
    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius - (self.lineWidth/2.0), 0.0, 6.28, 0);
    CGContextClip(context);
    CGContextClearRect(context, self.bounds);
    CGContextRestoreGState(context);
    
    CGFloat len = r/sqrt(2);
    
    //外圆弧
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextAddArc(context, x, y, r+10, self.startAngle, M_PI_4, 0);
    CGContextStrokePath(context);
    
    //左端点
    CGContextSaveGState(context);
    CGContextAddArc(context, x-len, y+len, 10, -M_PI_4, M_PI_4*3, 0);
    CGContextStrokePath(context);
    
    //内圆弧
    CGContextSaveGState(context);
    CGContextAddArc(context, x, y, r-10, self.startAngle, M_PI_4, 0);
    CGContextStrokePath(context);
    //右端点
    CGContextSaveGState(context);
    CGContextAddArc(context, x+len, y+len, 10, M_PI_4, M_PI_4*5, 0);
    CGContextStrokePath(context);
    
    //如果需要圆弧上面有字
    if (self.drowNumber) {
        self.drowNumber(r,x,y);
    }
    
    //标记
    CGContextSetLineWidth(context, self.lineWidth);
    [[startCircleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setStroke];
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius, 0.0, 6.28, 0);
    //标记背景色
    CGContextStrokePath(context);
    [markBackcolor setFill];
    [[startCircleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setStroke];
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius-1, 0.0, 6.28, 0);
    CGContextFillPath(context);
    //标记上面的字
    NSString *startMarkerStr = [NSString stringWithFormat:@"%.0f", sector.startValue+16];
    [self drawString:startMarkerStr
            withFont:drawInf.startMarkerFontSize
               color:[startCircleColor colorWithAlphaComponent:drawInf.startMarkerAlpha]
          withCenter:drawInf.startMarkerCenter];
}


- (YHSectorDrawingInformation) sectorToDrawInf:(YHSector *)sector {
    YHSectorDrawingInformation drawInf;
    
    drawInf.circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height /2);
    drawInf.radius = self.sectorsRadius;//圆半径
    
    drawInf.fullLine = sector.maxValue - sector.minValue;
    drawInf.circleOffset = sector.startValue - sector.minValue;
    drawInf.circleLine = sector.endValue - sector.startValue;
    drawInf.circleEmpty = sector.maxValue - sector.endValue;
    
    drawInf.circleOffsetAngle = (drawInf.circleOffset/drawInf.fullLine) * M_PI * 2 + self.startAngle;
    drawInf.circleLineAngle = (drawInf.circleLine/drawInf.fullLine) * M_PI * 2 + drawInf.circleOffsetAngle;
    drawInf.circleEmptyAngle = M_PI * 2 + self.startAngle;
    
    
    drawInf.startMarkerCenter = polarToDecart(drawInf.circleCenter, drawInf.radius, drawInf.circleOffsetAngle);
    
    drawInf.startMarkerRadius = self.markRadius;
    
    drawInf.startMarkerFontSize = 8;
    drawInf.startMarkerAlpha = 1.0;

    return drawInf;
}
//mark上面的字
- (void) drawString:(NSString *)s withFont:(CGFloat)fontSize color:(UIColor *)color withCenter:(CGPoint)center{
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
//                          NSForegroundColorAttributeName : color,
//                          NSParagraphStyleAttributeName : paragraph};
//
//    CGFloat x = center.x - (self.markRadius);
//    CGFloat y = center.y - (self.markRadius / 2);
//    CGRect textRect = CGRectMake(x, y, self.markRadius*2, self.markRadius);
//
//    [s drawInRect:textRect withAttributes:dic];
}
@end





@implementation YHSector

- (instancetype)init{
    if(self = [super init]){
        self.minValue = 0.0;
        self.maxValue = 100.0;
        self.startValue = 0.0;
        self.endValue = 50.0;
        self.tag = 0;
        self.color = [UIColor greenColor];
    }
    return self;
}

+ (instancetype) sector{
    return [[YHSector alloc] init];
}

+ (instancetype) sectorWithColor:(UIColor *)color{
    YHSector *sector = [self sector];
    sector.color = color;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color maxValue:(double)maxValue{
    YHSector *sector = [self sectorWithColor:color];
    sector.maxValue = maxValue;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color minValue:(double)minValue maxValue:(double)maxValue{
    YHSector *sector = [self sectorWithColor:color maxValue:maxValue];
    sector.minValue = minValue;
    return sector;
}

@end
