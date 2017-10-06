//
//  CALayer+CALayer_CircleBoard.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/5.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CALayer+CircleBoard.h"

@implementation CALayer (CALayer_CircleBoard)
- (void)addCircleBoardWithRadius:(CGFloat)radius boardColor:(UIColor *)boardColor boardWidth:(CGFloat)boardWidth{
    if(boardColor){
        self.borderColor = boardColor.CGColor;
    }
    self.borderWidth = boardWidth;
    self.cornerRadius = radius;
    self.masksToBounds = YES;
    
}
@end
