//
//  AskHelpViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AskHelpViewController.h"
#import "AskHelpCell.h"
#import <MessageUI/MessageUI.h>
@interface AskHelpViewController ()<AskHelpDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *jinjiArr;
@property (nonatomic, strong) NSMutableArray *guardianArr;
@property (nonatomic, strong) NSMutableArray *neighborArr;
@property (nonatomic, strong) NSMutableArray *communityArr;
@property (nonatomic, strong) NSMutableArray *oldArr;
@end

@implementation AskHelpViewController

- (NSMutableArray *)guardianArr{
    if (!_guardianArr) {
        _guardianArr = [NSMutableArray array];
    }
    return _guardianArr;
}

- (NSMutableArray *)neighborArr{
    if (!_neighborArr) {
        _neighborArr = [NSMutableArray array];
    }
    return _neighborArr;
}

- (NSMutableArray *)communityArr{
    if (!_communityArr) {
        _communityArr = [NSMutableArray array];
    }
    return _communityArr;
}

- (NSMutableArray *)oldArr{
    if (!_oldArr) {
        _oldArr = [NSMutableArray array];
    }
    return _oldArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"紧急求助";
    self.jinjiArr = @[@{@"title":@"报警",@"number":@"110"},@{@"title":@"火警",@"number":@"119"},@{@"title":@"医院",@"number":@"120"}];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData{
    NSDictionary *params = @{@"elderId":SharedUserInfo.elderId};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/emergency/getEmergencyContactList.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if ([showdata[@"contactList"] count]) {
            for (NSDictionary *dic in showdata[@"contactList"]) {
                if ([dic[@"type"] integerValue] == 1) {
                    [self.guardianArr addObject:dic];
                }
                else if ([dic[@"type"] integerValue] == 2){
                    [self.neighborArr addObject:dic];
                }
                else if ([dic[@"type"] integerValue] == 4){
                    [self.communityArr addObject:dic];
                }
                else if ([dic[@"type"] integerValue] == 3){
                    [self.oldArr addObject:dic];
                }
            }
            [self setUp];
        }
        else{
            [self setUp];
        }
    }];
}


- (void)setUp{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navHight, SIZEWIDTH, SIZEHEIGHT - navHight)];
    self.scrollView.backgroundColor = COLOR(240, 240, 240, 1);
    self.scrollView.contentSize = CGSizeMake(SIZEWIDTH,60 + (self.jinjiArr.count + self.guardianArr.count + self.neighborArr.count + self.communityArr.count + self.oldArr.count + 4) * 45);
    [self.view addSubview:self.scrollView];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SIZEWIDTH - 20, 135)];
    LRViewBorderRadius(view1, 10, 0, [UIColor clearColor]);
    view1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, view1.height + view1.y + 10, SIZEWIDTH - 20, (self.guardianArr.count + 1) * 45)];
    LRViewBorderRadius(view2, 10, 0, [UIColor clearColor]);
    view2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view2];
    
    UIView *view3 =  [[UIView alloc] initWithFrame:CGRectMake(10, view2.height + view2.y + 10, SIZEWIDTH - 20, (self.neighborArr.count + 1) * 45)];
    LRViewBorderRadius(view3, 10, 0, [UIColor clearColor]);
    view3.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view3];
    
    UIView *view5 =  [[UIView alloc] initWithFrame:CGRectMake(10, view3.height + view3.y + 10, SIZEWIDTH - 20, (self.oldArr.count + 1) * 45)];
    LRViewBorderRadius(view5, 10, 0, [UIColor clearColor]);
    view5.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view5];
    
    UIView *view4 =  [[UIView alloc] initWithFrame:CGRectMake(10, view5.height + view5.y + 10, SIZEWIDTH - 20, (self.communityArr.count + 1) * 45)];
    LRViewBorderRadius(view4, 10, 0, [UIColor clearColor]);
    view4.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view4];
    
    
    
    for (int i = 0 ; i < self.jinjiArr.count; i++) {
        AskHelpCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
        cell.delegate = self;
        [cell changeCell2];
        cell.y = 45 * i ;
        cell.nameLabel.text = self.jinjiArr[i][@"title"];
        cell.numLabel.text = self.jinjiArr[i][@"number"];
        [view1 addSubview:cell];
    }
    
    
    AskHelpCell *cell2 = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
    [cell2 changeCell1];
    cell2.nameLabel.text = @"监护人";
    [view2 addSubview:cell2];
    for (int i = 0 ; i < self.guardianArr.count; i++) {
        AskHelpCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
        cell.delegate = self;
        cell.y = 45 + 45 * i ;
        cell.nameLabel.text = self.guardianArr[i][@"name"];
        cell.numLabel.text = self.guardianArr[i][@"mobile"];
        [view2 addSubview:cell];
    }
    
    AskHelpCell *cell3 = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
    [cell3 changeCell1];
    cell3.nameLabel.text = @"邻里亲友";
    [view3 addSubview:cell3];
    for (int i = 0 ; i < self.neighborArr.count; i++) {
        AskHelpCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
        cell.delegate = self;
        cell.y = 45 + 45 * i ;
        cell.nameLabel.text = self.neighborArr[i][@"name"];
        cell.numLabel.text = self.neighborArr[i][@"mobile"];
        [view3 addSubview:cell];
    }
    
    AskHelpCell *cell5 = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
    [cell5 changeCell1];
    cell5.nameLabel.text = @"老人";
    [view5 addSubview:cell5];
    for (int i = 0 ; i < self.oldArr.count; i++) {
        AskHelpCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
        cell.delegate = self;
        cell.y = 45 + 45 * i ;
        cell.nameLabel.text = self.oldArr[i][@"name"];
        cell.numLabel.text = self.oldArr[i][@"mobile"];
        [view5 addSubview:cell];
    }
    
    AskHelpCell *cell4 = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
    [cell4 changeCell1];
    cell4.nameLabel.text = @"社区";
    [view4 addSubview:cell4];
    for (int i = 0 ; i < self.communityArr.count; i++) {
        AskHelpCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AskHelpCell" owner:self options:nil].firstObject;
        cell.delegate = self;
        cell.y = 45 + 45 * i ;
        cell.nameLabel.text = self.communityArr[i][@"name"];
        cell.numLabel.text = self.communityArr[i][@"mobile"];
        [view4 addSubview:cell];
    }
    
    
}

- (void)click:(NSString *)type num:(NSString *)num{
    if([type isEqualToString:@"phone"]){
        NSString *tel = [NSString stringWithFormat:@"tel://%@",num];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tel]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
    }
    else{
        NSString *tel = [NSString stringWithFormat:@"sms://%@",num];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tel]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
