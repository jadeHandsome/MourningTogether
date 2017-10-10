//
//  AddAddressView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/8.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddAddressView.h"
#import <AddressBookUI/AddressBookUI.h>
@interface AddAddressView()<ABPeoplePickerNavigationControllerDelegate>
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableDictionary *param;
@end
@implementation AddAddressView

- (void)setUpWithTag:(NSInteger)tag andParam:(NSMutableDictionary *)param andType:(NSInteger)type {
    
    UILabel *title = [[UILabel alloc]init];
    self.type = type;
    [self addSubview:title];
    self.param = param;
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
            textField.tag = 1;
            if (param[@"elderName"]) {
                textField.text = param[@"elderName"];
            } else {
                textField.text = param[@"otherName"];
            }
            
            [textField addTarget:self action:@selector(textFielDidChange:) forControlEvents:UIControlEventEditingChanged];
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
            [address addTarget:self action:@selector(chooseAdd) forControlEvents:UIControlEventTouchUpInside];
            [address setImage:[UIImage imageNamed:@"云医时代1-60"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            titleStr = @"手机";
            UITextField *textField = [[UITextField alloc]init];
            textField.text = param[@"mobile"];
            textField.tag = 2;
            [textField addTarget:self action:@selector(textFielDidChange:) forControlEvents:UIControlEventEditingChanged];
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
                women.tag = 50;
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
                man.tag = 51;
                [man setTitle:@"  男" forState:UIControlStateNormal];
                [man setTitleColor:LRRGBColor(140, 140, 140) forState:UIControlStateNormal];
                [man setImage:[UIImage imageNamed:@"云医时代1-59"] forState:UIControlStateNormal];
                [man setImage:[UIImage imageNamed:@"云医时代1-56"] forState:UIControlStateSelected];
                [man addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                if ([param[@"sex"] integerValue] == 1) {
                    [man setSelected:YES];
                } else if ([param[@"sex"] integerValue] == 2) {
                    [women setSelected:YES];
                }
            } else {
            
                titleStr = @"称呼";
                UITextField *textField = [[UITextField alloc]init];
                textField.text = param[@"nickname"];
                textField.tag = 3;
                [textField addTarget:self action:@selector(textFielDidChange:) forControlEvents:UIControlEventEditingChanged];
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
            textField.text = param[@"nickname"];
            textField.tag = 3;
            [textField addTarget:self action:@selector(textFielDidChange:) forControlEvents:UIControlEventEditingChanged];
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
            textField.text = param[@"idCard"];
            textField.tag = 4;
            [textField addTarget:self action:@selector(textFielDidChange:) forControlEvents:UIControlEventEditingChanged];
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
            textField.text = param[@"healthIds"];
            textField.tag = 5;
            [textField addTarget:self action:@selector(textFielDidChange:) forControlEvents:UIControlEventEditingChanged];
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
- (void)textFielDidChange:(UITextField *)textField {
    
   
        if (textField.tag == 1) {
            if (self.type == 1) {
                self.param[@"elderName"] = textField.text;
            } else {
                self.param[@"otherName"] = textField.text;
            }
        } else if (textField.tag == 2) {
            self.param[@"mobile"] = textField.text;
        } else if (textField.tag == 3) {
            self.param[@"nickname"] = textField.text;
        } else if (textField.tag == 4) {
            self.param[@"idCard"] = textField.text;
        } else {
            self.param[@"healthIds"] = textField.text;
        }
    
}
- (void)upData:(NSInteger)tag {
    if (tag == 1001) {
        for (UIView *sub in self.subviews) {
            if ([sub isKindOfClass:[UITextField class]]) {
                UITextField *textF = (UITextField *)sub;
                if (self.type == 1) {
                    textF.text = self.param[@"elderName"];
                } else {
                    textF.text = self.param[@"otherName"];
                }
                return;
                
            }
        }
    } else if (tag == 1002) {
        for (UIView *sub in self.subviews) {
            if ([sub isKindOfClass:[UITextField class]]) {
                UITextField *textF = (UITextField *)sub;
                textF.text = self.param[@"mobile"];
                return;
                
            }
        }
    }
    
}
- (void)sexBtnClick:(UIButton *)sender {
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            [btn setSelected:NO];
        }
    }
    if (sender.tag == 50) {
        self.param[@"sex"] = @2;
    } else {
        self.param[@"sex"] = @1;
    }
    [sender setSelected:YES];
}
- (void)chooseAdd {
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self.superVc presentViewController:picker animated:YES completion:nil];
}
//这个方法在用户取消选择时调用
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.superVc dismissViewControllerAnimated:YES completion:^{}];
}

//这个方法在用户选择一个联系人后调用
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    [self displayPerson:person];
    [self.superVc dismissViewControllerAnimated:YES completion:^{}];
}

//获得选中person的信息
- (void)displayPerson:(ABRecordRef)person
{
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *middleName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString *lastname = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSMutableString *nameStr = [NSMutableString string];
    if (lastname!=nil) {
        [nameStr appendString:lastname];
    }
    if (middleName!=nil) {
        [nameStr appendString:middleName];
    }
    if (firstName!=nil) {
        [nameStr appendString:firstName];
    }
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    //可以把-、+86、空格这些过滤掉
    NSString *phoneStr = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.type == 1) {
        self.param[@"elderName"] = nameStr;
    } else {
        self.param[@"otherName"] = nameStr;
    }
    self.param[@"mobile"] = phoneStr;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"choosePhoneFinish" object:nil];
    //[self.nameTextField setText:nameStr];
    //[self.phoneTextField setText:phoneStr];
}

@end
