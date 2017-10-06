//
//  CALayer+CALayer_CircleBoard.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/5.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CircleBoard)

- (void)addCircleBoardWithRadius:(CGFloat)radius boardColor:(UIColor *)boardColor boardWidth:(CGFloat)boardWidth;
@end
