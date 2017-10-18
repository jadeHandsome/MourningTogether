//
//  HealthyTypeView.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/11.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HealthyTypeView.h"
@interface HealthyTypeView()
@property (nonatomic, strong) UIView *btnView;//所有按钮的数组
@property (nonatomic, strong) NSMutableArray *paramArray;
@property (nonatomic, strong) NSDictionary *item;
@end
#define insetWith [UIScreen mainScreen].bounds.size.width * 0.1 * 0.25
#define weith [UIScreen mainScreen].bounds.size.width * 0.3 * 0.38
@implementation HealthyTypeView

- (void)setHealthWith:(NSDictionary *)item andParam:(NSMutableArray *)paramArray{
    UILabel *titleLabel = [[UILabel alloc]init];
    self.item = item;
    self.paramArray = paramArray;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.equalTo(@40);
    }];
    titleLabel.text = item[@"title"];
    self.btnView = [[UIView alloc]init];
    [self addSubview:_btnView];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(titleLabel.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    for (int i = 0; i < [item[@"items"] count]; i ++) {
        UIButton *button = [[UIButton alloc]init];
        NSDictionary *dic = item[@"items"][i];
        [button setTitle:dic[@"healthDescribe"] forState:UIControlStateNormal];
        
        
        button.tag = i + 321;
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
//        [button setBackgroundImage:[UIImage imageNamed:@"块2"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"块1"] forState:UIControlStateSelected];
        button.titleLabel.numberOfLines = 0;
        [button setTintColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnView addSubview:button];
        LRViewBorderRadius(button, 5, 0, [UIColor clearColor]);
        button.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    }
    [self addItemsWithArray:item[@"items"]];
    LRViewBorderRadius(self, 5, 0, [UIColor clearColor]);
    self.backgroundColor = [UIColor whiteColor];
}
- (void)btnClick:(UIButton *)sender {
    if (!self.canChooseMore) {
        for (UIView *sub in self.btnView.subviews) {
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)sub;
                [btn setSelected:NO];
                btn.backgroundColor = LRRGBAColor(242, 242, 242, 1);
                
            }
        }
    }
    
    [sender setSelected:YES];
    if (!self.canChooseMore) {
        for (NSDictionary *dic in self.paramArray) {
            if ([dic[@"healthType"] isEqualToString:self.item[@"items"][sender.tag - 321][@"healthType"] ]) {
                [self.paramArray removeObject:dic];
            }
        }
    }
    
    [self.paramArray addObject:self.item[@"items"][sender.tag - 321]];
    sender.backgroundColor = LRRGBColor(85, 183, 204);
}
- (void)addItemsWithArray:(NSArray *)array {
    // __block UIView *lastView = self.btnView;
    if (self.btnView.subviews.count < 3) {
        NSLog(@"%ld",self.btnView.subviews.count);
        UIView *lastView = self.btnView;
        // NSLog(@"%@",self.btnView.subviews[0]);
        
        for (int i = 0; i < self.btnView.subviews.count; i ++) {
            UIView *view = self.btnView.subviews[i];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(lastView.mas_left).with.offset(10);
                }
                else {
                    make.left.equalTo(lastView.mas_right).with.offset(insetWith);
                }
                make.top.equalTo(self.btnView).with.offset(0);
                make.height.equalTo(@(weith));
                make.width.equalTo(@(([UIScreen mainScreen].bounds.size.width - 20 - 4 * insetWith)/3));
            }];
            lastView = view;
        }
    }
    else if (self.btnView.subviews.count >= 3) {
        
        UIView *lastView = self.btnView;
        for (int i = 0; i < self.btnView.subviews.count; i ++) {
            UIView *view = self.btnView.subviews[i];
            if (i < 3 ) {
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i == 0) {
                        make.left.equalTo(lastView.mas_left).with.offset(10);
                    }
                    else {
                        make.left.equalTo(lastView.mas_right).with.offset(insetWith);
                    }
                    
                    make.top.equalTo(self.btnView).with.offset(0);
                    make.height.equalTo(@(weith));
                    make.width.equalTo(@(([UIScreen mainScreen].bounds.size.width - 20 - 4 * insetWith)/3));
                }];
                lastView = view;
                
            }else if (i > 2) {
                long lastViewIndex = i - 3;
                lastView = self.btnView.subviews[lastViewIndex];
                //UIView *view = self.btnView.subviews[i];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    //if (i%3 == 0) {
                    make.left.equalTo(lastView.mas_left);
                    //}
                    //                    else {
                    //                        make.left.equalTo(lastView.mas_right);
                    //                    }
                    
                    make.top.equalTo(lastView.mas_bottom).with.offset(20);
                    make.height.equalTo(@(weith));
                    
                    make.width.equalTo(@(([UIScreen mainScreen].bounds.size.width - 20 - 4 * insetWith)/3));
                }];
            }
        }
        
    }
    
}
@end
