//
//  YHArcCircleSlider.h
//  YHArcSlider
//
//  Created by baiwei－mac on 16/4/18.
//  Copyright © 2016年 BWDV. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct{
    double radius;
    double angle;
} YHPolarCoordinate;

CGFloat toDegrees (CGFloat radians);
CGFloat toRadians (CGFloat degrees);

CGFloat segmentAngle (CGPoint startPoint, CGPoint endPoint);
CGFloat segmentLength(CGPoint startPoint, CGPoint endPoint);

CGPoint polarToDecart(CGPoint startPoint, CGFloat radius, CGFloat angle);
YHPolarCoordinate decartToPolar(CGPoint center, CGPoint point);
