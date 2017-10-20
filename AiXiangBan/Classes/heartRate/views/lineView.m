//
//  lineView.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "lineView.h"
// 文件头部添加  宏定义
#define  PI 3.1415926
@implementation lineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 获取当前环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 保存当前环境，便于以后恢复
    CGContextSaveGState(context);
    
    /////////////////////////////////////////////////////////////////
    // 公共数据
    float fdistance_left_frame = 30.0;                    // 左侧X轴距离边框的宽度，用于绘制文本
    float fdistance_top_frame = 15.0;                  // 上侧Y轴距离边框的宽度
    float fdistance_bottom_frame = 15.0;                  // 左侧Y轴距离边框的宽度
    float fdistance_right_frame = 10.0;                   // 左侧X轴距离边框的宽度
    float fdraw_line_height = rect.size.height - fdistance_bottom_frame - fdistance_top_frame;  // 绘制坐标的高度
    float fdraw_line_width = rect.size.width - fdistance_left_frame
    - fdistance_right_frame;  // 绘制坐标的宽度
    
    float f_x_axis_scale_number = self.xArr.count ;                    // X轴大刻度数
    float f_y_axis_scale_number = self.yArr.count ;                    // Y轴刻度数
    float x_unit_distance_scale = 0.0;                    // X轴刻度的偏移量
    float y_unit_distance_scale = 0.0;                    // Y轴刻度的偏移量
    float x_unit_scale = 0.0;                             // X轴刻度的跨度(一个比例单元)
    float y_unit_scale = 0.0;                             // Y轴刻度的跨度(一个比例单元)
    
    // 开始画X轴
    float left_bottom_x = rect.origin.x + fdistance_left_frame;
    float left_bottom_y = rect.origin.y + fdraw_line_height + fdistance_top_frame;
    CGPoint point_origin = CGPointMake(left_bottom_x, left_bottom_y);              // 坐标轴原点
    
    // 定义一个开始路径
    UIBezierPath * x_startPath = [UIBezierPath bezierPath];
    [x_startPath  setLineWidth:1.5];
    
    [x_startPath moveToPoint:point_origin];                                        // 设置起点（坐标原点）
    for (int x = 0; x < f_x_axis_scale_number; x++)                                // 画直线
    {
        x_unit_scale = fdraw_line_width/(f_x_axis_scale_number-1);               // 一级等分大刻度
        x_unit_distance_scale = x * x_unit_scale;                            // 相对原点的偏移点
        [x_startPath addLineToPoint:CGPointMake(left_bottom_x + x_unit_distance_scale, left_bottom_y)];
        
        // “—”Y轴下部绘制文本
        float x_text_left_certer = left_bottom_x;
        float x_text_rect_left = x_text_left_certer + x_unit_distance_scale - 3;
        float x_text_rect_top = left_bottom_y + 2;
        float x_text_rect_width = 15;
        // +10 -10 ，给文字20个像素的宽度
        float x_text_rect_height = 16;
        
        CGRect x_axis_rect = CGRectMake(x_text_rect_left, x_text_rect_top, x_text_rect_width, x_text_rect_height);
        
        CGContextSetLineWidth(context, 1.0);
        CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
        UIFont  *font = [UIFont boldSystemFontOfSize:12.0];                         // 字体用12号
        NSString * x_strtext = self.xArr[x];             // 绘制X轴刻度值
        [x_strtext drawInRect:x_axis_rect withFont:font];
        
        
        
        if (0 == x)
        {
            
            // 开始画Y轴
            UIBezierPath * y_startPath = [UIBezierPath bezierPath];
            [y_startPath  setLineWidth:1.5];
            [y_startPath  moveToPoint:point_origin];                 // Y轴的起始点也是X轴的刻度起始点
            
            for (int y = 0; y < f_y_axis_scale_number; y++)                          // 画直线
            {
                
                
                y_unit_scale = fdraw_line_height/(f_y_axis_scale_number-1);                    // 一级等分大刻度
                y_unit_distance_scale = y * y_unit_scale;                                  // 相对原点的偏移点
                [y_startPath addLineToPoint:CGPointMake(left_bottom_x, left_bottom_y - y_unit_distance_scale)];
                
                // “|”X轴左侧绘制文本
                float text_height_certer = left_bottom_y;
                float text_rect_top = text_height_certer - 8 - y_unit_distance_scale;
                float text_rect_bottom = text_height_certer + 8 - y_unit_distance_scale;    // +8 -8 ，给文字16个像素的高度
                float text_rect_height = 16;
                CGRect y_axis_rect = CGRectMake(2, text_rect_top, fdistance_left_frame, text_rect_height);
                
                
                CGContextSetLineWidth(context, 1.5);                             // 线宽度
                CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
                UIFont  *font = [UIFont boldSystemFontOfSize:12.0];              // 字体用12号
                //                NSString * y_strtext = [NSString stringWithFormat:@%zi.00,y];// 绘制Y轴刻度值
                
                NSString * y_strtext = [self.yArr objectAtIndex:y];
                  // 绘制Y轴刻度值
                [y_strtext drawInRect:y_axis_rect withFont:font];
                
                if (y == 0){
                    
                } else {
                    float fscale_width = 5.0;
                    // |X轴绘制右侧刻度短线
                    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);// 线条颜色
                    CGContextMoveToPoint(context, left_bottom_x, left_bottom_y - y_unit_distance_scale);
                    CGContextAddLineToPoint(context, left_bottom_x + fscale_width, left_bottom_y - y_unit_distance_scale);
                    CGContextStrokePath(context);
                }
                
            }
            [y_startPath stroke];   // Draws line 根据坐标点连线
            
        } else
        {
            float fscale_width = 5.0;
            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);      // 线条颜色
            CGContextMoveToPoint(context, left_bottom_x + x_unit_distance_scale, left_bottom_y );
            CGContextAddLineToPoint(context, left_bottom_x + x_unit_distance_scale, left_bottom_y - fscale_width);
            CGContextStrokePath(context);
        }
    }
    [x_startPath stroke];   // Draws line 根据坐标点连线
    
    [[UIColor blueColor] setFill];
    [x_startPath fill];
    
    
    // |X轴绘制虚线，横向虚线
    CGFloat dashArray[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0, dashArray, 2);
    CGContextSetRGBStrokeColor(context,0.5, 0.5, 0.5, 0.5);// 线条颜色
    for (int y = 1; y < f_y_axis_scale_number + 1; y++)    // 画虚线
    {
        y_unit_distance_scale = y * (y_unit_scale);        // 一级等分大刻度
        CGContextMoveToPoint(context, left_bottom_x + 5, left_bottom_y - y_unit_distance_scale);
        CGContextAddLineToPoint(context, left_bottom_x + fdraw_line_width, left_bottom_y - y_unit_distance_scale);
    }
    for (int x = 1; x < f_x_axis_scale_number + 1 ; x++)    // 画虚线
    {
        x_unit_distance_scale = x * (x_unit_scale);        // 一级等分大刻度
        CGContextMoveToPoint(context, point_origin.x + x_unit_distance_scale, point_origin.y - 5);
        CGContextAddLineToPoint(context, point_origin.x + x_unit_distance_scale, point_origin.y - fdraw_line_height + fdistance_bottom_frame + 3 - fdistance_top_frame);
    }
    CGContextStrokePath(context);
    
//    // 开始绘制曲线图
//    CGContextSetLineDash(context, 0.0,NULL, 0);            // 还原画笔
//    CGContextSetLineWidth(context,1.0);                    // 设置为实线画笔
//    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 0.5);   // 线条颜色
//
//    for (int a = 0; a < self.xArr.count; a++)
//    {
//        // Y轴日期倒着遍历，这里数据也倒着遍历
//        float fdata = [[self.xArr objectAtIndex: self.xArr.count-1 - a] floatValue];
//        CGPoint data_point = CGPointMake(point_origin.x + a * y_unit_scale, point_origin.y - fdata * x_unit_scale);                                 // 坐标轴原点
//
//        if (0 == a)
//        {
//            CGContextMoveToPoint(context, data_point.x, data_point.y);
//        }
//        else
//        {
//            CGContextAddLineToPoint(context, data_point.x, data_point.y);
//        }
//        NSLog(@"%zi == (%f, %f)", a, data_point.x, data_point.y);
//
//    }
//    CGContextStrokePath(context);
//
//    // 开始边框圆点
//    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);//画笔线的颜色
//    CGContextSetLineWidth(context, 2.0);//线的宽度
//    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
//    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//
//    for (int a = 0; a < self.xArr.count; a++)
//    {
//        // Y轴日期倒着遍历，这里数据也倒着遍历
//        float fdata = [[self.xArr objectAtIndex: self.xArr.count-1 - a] floatValue];
//        CGPoint data_point = CGPointMake(point_origin.x + a * y_unit_scale, point_origin.y - fdata * x_unit_scale);                                 // 坐标轴原点
//
//        CGContextAddArc(context, data_point.x, data_point.y, 1, 0, 2 * PI, 0); //添加一个圆
//
//    }
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
    
}


@end
