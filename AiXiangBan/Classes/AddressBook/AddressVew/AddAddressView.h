//
//  AddAddressView.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/8.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressView : UIView
@property (nonatomic, strong) UIViewController *superVc;
- (void)setUpWithTag:(NSInteger)tag andParam:(NSMutableDictionary *)param andType:(NSInteger)type;
- (void)upData:(NSInteger)tag;
@end
