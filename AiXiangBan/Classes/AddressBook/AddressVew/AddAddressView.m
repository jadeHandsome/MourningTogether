//
//  AddAddressView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/8.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddAddressView.h"

@implementation AddAddressView

- (void)setUpWithTag:(NSInteger)tag andParam:(NSMutableDictionary *)param andType:(NSInteger)type {
    UILabel *title = [[UILabel alloc]init];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    title.textColor = LRRGBColor(200, 200, 200);
    title.font = [UIFont systemFontOfSize:16];
    NSString *titleStr = nil;
    switch (tag) {
        case 1:
        {
            titleStr = @"姓名";
            UITextField *textField = [[UITextField alloc]init];
            textField.textAlignment = NSTextAlignmentRight;
            [self addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).with.offset(10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                
                
            }];
            UIButton *address = [[UIButton alloc]init];
            [self addSubview:address];
            [address mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(textField.mas_right).with.offset(10);
            }];
            [address setImage:[UIImage imageNamed:@"云医时代1-60"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            titleStr = @"手机";
            UITextField *textField = [[UITextField alloc]init];
            textField.textAlignment = NSTextAlignmentRight;
            [self addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).with.offset(10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.right.equalTo(self.mas_right).with.offset(-10);
                
            }];
        }
            break;
        case 3:
        {
            if (type == 1) {
                titleStr = @"性别";
                UIButton *women = [[UIButton alloc]init];
                [self addSubview:women];
                [women mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right).with.offset(-10);
                    make.centerY.equalTo(self.mas_centerY);
                    
                }];
                [women setTitle:@"  女" forState:UIControlStateNormal];
                [women setTitleColor:LRRGBColor(140, 140, 140) forState:UIControlStateNormal];
                [women setImage:[UIImage imageNamed:@"云医时代1-59"] forState:UIControlStateNormal];
                [women setImage:[UIImage imageNamed:@"云医时代1-56"] forState:UIControlStateSelected];
                [women addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                UIButton *man = [[UIButton alloc]init];
                [self addSubview:man];
                [man mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(women.mas_left).with.offset(-20);
                    make.centerY.equalTo(self.mas_centerY);
                    
                }];
                [man setTitle:@"  男" forState:UIControlStateNormal];
                [man setTitleColor:LRRGBColor(140, 140, 140) forState:UIControlStateNormal];
                [man setImage:[UIImage imageNamed:@"云医时代1-59"] forState:UIControlStateNormal];
                [man setImage:[UIImage imageNamed:@"云医时代1-56"] forState:UIControlStateSelected];
                [man addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
            
                titleStr = @"称呼";
                UITextField *textField = [[UITextField alloc]init];
                textField.textAlignment = NSTextAlignmentRight;
                [self addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(title.mas_right).with.offset(10);
                    make.centerY.equalTo(self.mas_centerY);
                    make.height.equalTo(@30);
                    make.right.equalTo(self.mas_right).with.offset(-10);
                    
                }];
            }
        }
            break;
        case 4:
        {
            titleStr = @"称呼";
            UITextField *textField = [[UITextField alloc]init];
            textField.textAlignment = NSTextAlignmentRight;
            [self addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).with.offset(10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.right.equalTo(self.mas_right).with.offset(-10);
                
            }];
        }
            break;
        case 5:
        {
            titleStr = @"身份证号";
            UITextField *textField = [[UITextField alloc]init];
            textField.textAlignment = NSTextAlignmentRight;
            [self addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).with.offset(10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.right.equalTo(self.mas_right).with.offset(-10);
                
            }];
        }
            break;
        case 6:
        {
            titleStr = @"详细地址";
            UIImageView *right = [[UIImageView alloc]init];
            [self addSubview:right];
            [right mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.centerY.equalTo(self.mas_centerY);
            }];
            right.contentMode = UIViewContentModeRight;
            right.image = [UIImage imageNamed:@"云医时代1-58"];
        }
            break;
        case 7:
        {
            titleStr = @"健康状况";
            UIImageView *right = [[UIImageView alloc]init];
            [self addSubview:right];
            [right mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.centerY.equalTo(self.mas_centerY);
            }];
            right.contentMode = UIViewContentModeRight;
            right.image = [UIImage imageNamed:@"云医时代1-58"];
        }
            break;
        case 8:
        {
            titleStr = @"所在区域";
            UIImageView *right = [[UIImageView alloc]init];
            [self addSubview:right];
            [right mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.centerY.equalTo(self.mas_centerY);
            }];
            right.contentMode = UIViewContentModeRight;
            right.image = [UIImage imageNamed:@"云医时代1-58"];
        }
            break;
        case 9:
        {
            titleStr = @"社区工作人员";
            UITextField *textField = [[UITextField alloc]init];
            textField.textAlignment = NSTextAlignmentRight;
            [self addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).with.offset(10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.right.equalTo(self.mas_right).with.offset(-10);
                
            }];
        }
            break;
            
        default:
            break;
    }
    title.text = titleStr;
    UIView *linView = [[UIView alloc]init];
    [self addSubview:linView];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    linView.backgroundColor = LRRGBColor(236, 236, 236);
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//    [self addGestureRecognizer:tap];
//    [tap addTarget:self action:@selector(click)];
}
- (void)sexBtnClick:(UIButton *)sender {
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            [btn setSelected:NO];
        }
    }
    [sender setSelected:YES];
}
@end
