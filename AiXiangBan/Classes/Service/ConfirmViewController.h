//
//  ConfirmViewController.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"

@interface ConfirmViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *money;
@end
