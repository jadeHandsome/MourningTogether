//
//  AllDeviceCell.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/16.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectBlock)(BOOL);
@interface AllDeviceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) SelectBlock block;
@end
