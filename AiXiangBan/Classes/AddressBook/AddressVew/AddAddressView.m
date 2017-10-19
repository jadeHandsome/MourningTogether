//
//  AddAddressView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/8.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddAddressView.h"
#import <AddressBookUI/AddressBookUI.h>
#import "HealthyTypeViewController.h"
#import "ArearViewController.h"
@interface AddAddressView()<ABPeoplePickerNavigationControllerDelegate>
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UILabel *chooselabel;
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
            UIButton *address = [[UIButton alloc]init];
            [self addSubview:address];
            [address mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(@40);
                //make.left.equalTo(textField.mas_right).with.offset(10);
            }];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).with.offset(10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.right.equalTo(address.mas_left).with.offset(-10);
                make.width.equalTo(@200);
                
            }];
            
            [address addTarget:self action:@selector(chooseAdd) forControlEvents:UIControlEventTouchUpInside];
            [address setImage:[UIImage imageNamed:@"云医时代1-60"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            titleStr = @"手机";
            UITextField *textField = [[UITextField alloc]init];
            textField.keyboardType = UIKeyboardTypePhonePad;
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
            titleStr = @"年龄";
            UITextField *textField = [[UITextField alloc]init];
            if (param[@"age"]) {
                textField.text = [NSString stringWithFormat:@"%@",param[@"age"]];
            }
            textField.keyboardType = UIKeyboardTypeNumberPad;
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
        case 5:
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
        case 6:
        {
            titleStr = @"身份证号";
            UITextField *textField = [[UITextField alloc]init];
            textField.text = param[@"idCard"];
            textField.tag = 4;
            textField.keyboardType = UIKeyboardTypeNumberPad;
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
        case 7:
        {
            titleStr = @"所在地区";
            UIImageView *right = [[UIImageView alloc]init];
            [self addSubview:right];
            [right mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.centerY.equalTo(self.mas_centerY);
            }];
            right.contentMode = UIViewContentModeRight;
            right.image = [UIImage imageNamed:@"云医时代1-58"];
            UILabel *chooseLabel = [[UILabel alloc]init];
            [self addSubview:chooseLabel];
            _chooselabel = chooseLabel;
            [chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(right.mas_left).with.offset(-10);
                make.centerY.equalTo(right.mas_centerY);
            }];
            chooseLabel.textColor = LRRGBColor(85, 183, 204);
            if (param[@"address"]) {
                chooseLabel.text = param[@"address"];
            }
            
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [self addGestureRecognizer:tap];
            [tap addTarget:self action:@selector(addressClick)];
        }
            break;
        case 8:
        {
            titleStr = @"详细地址";
            UITextField *textField = [[UITextField alloc]init];
            textField.text = param[@"detailAddr"];
            textField.tag = 6;
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
        case 9:
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [self addGestureRecognizer:tap];
            [tap addTarget:self action:@selector(chooseHealthy)];
            UILabel *chooseLabel = [[UILabel alloc]init];
            _chooselabel = chooseLabel;
            _chooselabel.hidden = YES;
            [self addSubview:chooseLabel];
            [chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(right.mas_left).with.offset(-10);
                make.centerY.equalTo(right.mas_centerY);
            }];
            chooseLabel.textColor = LRRGBColor(85, 183, 204);
            chooseLabel.text = @"已选";
        }
            break;
        case 10:
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
            UILabel *chooseLabel = [[UILabel alloc]init];
            chooseLabel.tag = 10000;
            [self addSubview:chooseLabel];
            _chooselabel = chooseLabel;
        
            [chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(right.mas_left).with.offset(-10);
                make.centerY.equalTo(right.mas_centerY);
            }];
            chooseLabel.textColor = LRRGBColor(85, 183, 204);
            chooseLabel.text = self.param[@"communityName"];
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [self addGestureRecognizer:tap];
            [tap addTarget:self action:@selector(commuitClick)];
        }
            break;
        case 11:
        {
            titleStr = @"社区工作人员";
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [self addGestureRecognizer:tap];
            [tap addTarget:self action:@selector(commuitClick)];
            UILabel *chooseLabel = [[UILabel alloc]init];
            chooseLabel.tag = 10001;
            _chooselabel = chooseLabel;
            [self addSubview:chooseLabel];
            [chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.centerY.equalTo(self.mas_centerY);
            }];
            chooseLabel.textColor = LRRGBColor(85, 183, 204);
            chooseLabel.text = param[@"communityWorker"];
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
- (void)addressClick {
    //详细地址
    ArearViewController *health = [[ArearViewController alloc]init];
    health.block = ^(NSString *result) {
        self.param[@"address"] = result;
        _chooselabel.text = result;
        _chooselabel.hidden = NO;
    };

    
    
    [self.superVc.navigationController pushViewController:health animated:YES];
}
- (void)commuitClick {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/community/getCommunityList.do" params:@{@"offset":@"0",@"size":@"20"} withModel:nil waitView:self complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择社区工作人员" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        for (NSDictionary *dic in showdata[@"communityList"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:dic[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //_chooselabel.text = dic[@"worker"];
                weakSelf.param[@"communityId"] = dic[@"communityId"];
                weakSelf.param[@"communityWorker"] = dic[@"worker"];
                weakSelf.param[@"communityName"] = dic[@"name"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"choosePhoneFinish" object:nil];
            }];
            [alert addAction:action];
        }
        [self.superVc presentViewController:alert animated:YES completion:^{
            
        }];
    }];
}
- (void)chooseHealthy {
    HealthyTypeViewController *health = [[HealthyTypeViewController alloc]init];
    health.block = ^(NSArray *paramArray) {
        NSMutableString *heath = [NSMutableString string];
        for (NSDictionary *dic in paramArray) {
            if ([paramArray indexOfObject:dic] < paramArray.count - 1) {
                [heath appendString:[dic[@"healthId"] stringByAppendingString:@","]];
            } else {
                [heath appendString:dic[@"healthId"]];
            }
        }
        self.param[@"healthIds"] = heath;
        _chooselabel.hidden = NO;
    
    };
    
       
    [self.superVc.navigationController pushViewController:health animated:YES];
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
        } else if (textField.tag == 5){
            self.param[@"age"] = textField.text;
        } else if (textField.tag == 6) {
            self.param[@"detailAddr"] = textField.text;
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
    } else {
        if (self.chooselabel.tag == 10000) {
            self.chooselabel.text = self.param[@"communityName"];
        } else if (self.chooselabel.tag == 10001) {
            self.chooselabel.text = self.param[@"communityWorker"];
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
