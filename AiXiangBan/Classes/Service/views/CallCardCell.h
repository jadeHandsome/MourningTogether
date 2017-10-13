//
//  CallCardCell.h
//  孝相伴
//
//  Created by MAC on 17/10/13.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SwitchBlock)(void);
typedef void(^DetailBlock)(void);
@interface CallCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) SwitchBlock switchBlock;
@property (nonatomic, strong) DetailBlock detailBlock;
@end
