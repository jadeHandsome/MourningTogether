//
//  LookCell.h
//  孝相伴
//
//  Created by MAC on 17/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LooCellBlock)(void);

@interface LookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) LooCellBlock block;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

@end
