//
//  TRAnnotation.h
//  TRFindDeals
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface TRAnnotation : NSObject<MAAnnotation>
//坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//title
@property (nonatomic, copy) NSString *title;
//subtitle
@property (nonatomic, copy) NSString *subtitle;
//image
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSInteger anTag;





@end
