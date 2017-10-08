//
//  RechargeCell.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, assign) BOOL isChoose;
@end
