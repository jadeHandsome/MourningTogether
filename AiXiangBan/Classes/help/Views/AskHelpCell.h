//
//  AskHelpCell.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AskHelpDelegate

-(void)click:(NSString *)type num:(NSString *)num;

@end

@interface AskHelpCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, assign) BOOL isChangeCell2;
@property (weak, nonatomic) id<AskHelpDelegate> delegate;

- (void)changeCell1;

- (void)changeCell2;
@end
