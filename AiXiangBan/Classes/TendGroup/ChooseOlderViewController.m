//
//  ChooseOlderViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/14.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ChooseOlderViewController.h"
#import "AddressView.h"
@interface ChooseOlderViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIScrollView *myScroll;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *chooseData;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) NSString *searchStr;
@end

@implementation ChooseOlderViewController
- (NSMutableArray *)chooseData {
    if (!_chooseData) {
        _chooseData = [NSMutableArray array];
    }
    return _chooseData;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchStr = searchBar.text;
}
- (void)setSearchStr:(NSString *)searchStr {
    _searchStr = searchStr;
    [self setLayout:searchStr];
   
    
}
- (void)setLayout:(NSString *)searchStr {
    [self reset];
    if (searchStr.length == 0) {
        return;
    }
    NSArray *array = [self.dataArray copy];
    if (self.type == 1) {
        for (NSDictionary *dic in array) {
            if (![dic[@"elderName"] containsString:searchStr] && ![dic[@"mobile"] containsString:searchStr]) {
                NSInteger index = [array indexOfObject:dic] + 1000;
                AddressView *add = [self.mainView viewWithTag:index];
                [add mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }
        }
    } else {
        for (NSDictionary *dic in array) {
            if (![dic[@"otherName"] containsString:searchStr] && ![dic[@"mobile"] containsString:searchStr]) {
                NSInteger index = [array indexOfObject:dic] + 1000;
                AddressView *add = [self.mainView viewWithTag:index];
                [add mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }
        }
    }
}
- (void)reset {
    for (UIView *sub in self.mainView.subviews) {
        if ([sub isKindOfClass:[AddressView class]]) {
            AddressView *add = (AddressView *)sub;
            [add mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
            }];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    if (self.isDelet) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    }
    
    if (self.isDelet) {
        if (self.type == 1) {
            self.dataArray = [self.oldData[@"familyElderList"] mutableCopy];
            [self setUp];
        } else if (self.type == 2) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in self.oldData[@"familyOtherList"]) {
                if ([dic[@"contactType"] integerValue] == 1) {
                    [array addObject:dic];
                }
            }
            self.dataArray = array;
            [self setUp];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in self.oldData[@"familyOtherList"]) {
                if ([dic[@"contactType"] integerValue] == 2) {
                    [array addObject:dic];
                }
            }
            self.dataArray = array;
            [self setUp];
        }
    } else {
        if (self.type == 1) {
            [self getOldManData];
            self.navigationItem.title = @"老人";
        } else if (self.type == 2) {
            [self getJianhuData];
            self.navigationItem.title = @"监护人";
        } else {
            [self getQinQiData];
            self.navigationItem.title = @"亲属邻里";
        }
        
    }
}
//确认添加
- (void)finish {
    
    if (self.type == 1) {
        if (!self.oldData) {
            NSString *typeStr = @"";
            for (NSDictionary *dic in self.chooseData) {
                typeStr = [[@"" stringByAppendingString:dic[@"elderId"]] stringByAppendingString:@"-3"];
            }
            [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:@"mgr/family/addFamily.do" params:@{@"idTypes":typeStr} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
                if (showdata == nil) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            NSMutableString *typeStr = [NSMutableString string];
            for (NSDictionary *dic in self.chooseData) {
                if ([self.chooseData indexOfObject:dic] == self.chooseData.count - 1) {
                    if (self.isDelet) {
                        [typeStr appendString:dic[@"familyElderId"]];
                    } else {
                        [typeStr appendString:dic[@"elderId"]];
                    }
                    
                    
                } else {
                    if (self.isDelet ) {
                        [typeStr appendString:[dic[@"familyElderId"] stringByAppendingString:@","]];
                    } else {
                        [typeStr appendString:[dic[@"elderId"] stringByAppendingString:@","]];
                    }
                    
                    
                }
                
            }
            NSString *path = @"";
            if (self.isDelet) {
                path = @"mgr/family/deleteFamilyElder.do";
            } else {
                path = @"mgr/family/addFamilyElder.do";
            }
            [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:path params:@{@"elderIds":typeStr,@"familyId":self.oldData[@"familyId"]} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
                if (showdata == nil) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
    } else {
        NSString *path = @"";
        if (self.isDelet) {
            path = @"mgr/family/deleteFamilyOther.do";
        } else {
            path = @"mgr/family/addFamilyOther.do";
        }
        NSMutableString *typeStr = [NSMutableString string];
        for (NSDictionary *dic in self.chooseData) {
            if ([self.chooseData indexOfObject:dic] == self.chooseData.count - 1) {
                if (self.isDelet) {
                    [typeStr appendString:dic[@"familyOtherId"]];
                } else {
                    [typeStr appendString:dic[@"otherId"]];
                }
                
            } else {
                if (self.isDelet) {
                    [typeStr appendString:[dic[@"familyOtherId"] stringByAppendingString:@","]];
                } else {
                    [typeStr appendString:[dic[@"otherId"] stringByAppendingString:@","]];
                }
                
                
            }
        }
        [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:path params:@{@"familyId":self.oldData[@"familyId"],@"otherIds":typeStr} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}
- (void)setUp {
    for (UIView *sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
    self.searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight + 10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@35);
    }];
    self.searchBar.placeholder = @"搜索";
    LRViewBorderRadius(self.searchBar, 5, 0, [UIColor clearColor]);
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
        
        UIScrollView *subS = [[UIScrollView alloc]init];
        [self.view addSubview:subS];
        [subS mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBar.mas_bottom).with.offset(10);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }];
        subS.backgroundColor = [UIColor clearColor];
        _myScroll = subS;
        subS.contentSize = CGSizeMake(0, [self.dataArray count] * 60);
        if (self.type == 1) {
            if (!self.isDelet) {
                [KRBaseTool tableViewAddRefreshFooter:subS withTarget:self refreshingAction:@selector(getOldManData)];
            }
            
        } else if (self.type == 2) {
            if (!self.isDelet) {
                [KRBaseTool tableViewAddRefreshFooter:subS withTarget:self refreshingAction:@selector(getJianhuData)];
            }
            
        } else {
            if (!self.isDelet) {
                [KRBaseTool tableViewAddRefreshFooter:subS withTarget:self refreshingAction:@selector(getQinQiData)];
            }
            
        }
        
        UIView *secondView = [[UIView alloc]init];
    self.mainView = secondView;
        secondView.backgroundColor = [UIColor whiteColor];
        [subS addSubview:secondView];
        LRViewBorderRadius(secondView, 5, 0, [UIColor clearColor]);
        [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subS.mas_top);
            make.height.equalTo(@([self.dataArray count] * 60));
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
        }];
        UIView *bottomTemp = secondView;
        for (int j = 0; j < [self.dataArray count]; j ++) {
            AddressView *address = [[AddressView alloc]init];
            address.tag = j + 1000;
            [secondView addSubview:address];
            if (self.type == 1 && !self.isDelet) {
                NSArray *array = self.oldData[@"familyElderList"] ;
                for (NSDictionary *dic in array) {
                    if ([dic[@"familyElderId"] isEqualToString:self.dataArray[j][@"elderId"] ]) {
                        address.isChoose = YES;
                    }
                }
                if ([self.dataArray[j][@"flag"] integerValue]) {
                    address.userInteractionEnabled = NO;
                }
            } else {
                if (!self.isDelet) {
                    NSArray *array = self.oldData[@"familyOtherList"] ;
                    for (NSDictionary *dic in array) {
                        if ([dic[@"familyOtherId"] isEqualToString:self.dataArray[j][@"otherId"] ]) {
                            address.isChoose = YES;
                        }
                    }
                }
                
            }
            address.isAdd = YES;
            [address mas_makeConstraints:^(MASConstraintMaker *make) {
                if (j == 0) {
                    make.top.equalTo(bottomTemp.mas_top);
                } else {
                    make.top.equalTo(bottomTemp.mas_bottom);
                }
                make.left.equalTo(secondView.mas_left);
                make.right.equalTo(secondView.mas_right);
                make.height.equalTo(@60);
            }];
            address.addBlock = ^(NSDictionary *dic, BOOL isChoose) {
                if (isChoose) {
                    [self.chooseData addObject:dic];
                    
                } else {
                    [self.chooseData removeObject:dic];
                }
            };
            [address setUpWithDic:self.dataArray[j] withClickHandle:^(id responseObject) {
                NSLog(@"%@",responseObject);

            }];
            bottomTemp = address;
            
        }
}
#pragma -- 获取所有数据
//获取老人数据
- (void)getOldManData {
    
    NSInteger  count = [self.dataArray count];
    
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/elder/getElderList.do" params:@{@"offset":@(count),@"size":@10} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [self.myScroll.mj_footer endRefreshing];
        if (showdata == nil) {
            return ;
        }
        if ([showdata[@"elderList"] count] == 0 && count == 0) {
            self.dataArray = [NSMutableArray array];
        } else {
          [self.dataArray addObjectsFromArray:showdata[@"elderList"]];
        }
        [self setUp];
    }];
}
//获取监护人数据
- (void)getJianhuData {
    
    NSInteger  count = [self.dataArray count];
    
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/other/getOtherList.do" params:@{@"offset":@(count),@"size":@10,@"contactType":@"1"} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [self.myScroll.mj_footer endRefreshing];
        if (showdata == nil) {
            return ;
        }
        if ([showdata[@"otherList"] count] == 0 && count == 0) {
            self.dataArray = [NSMutableArray array];
        } else {
            [self.dataArray addObjectsFromArray:showdata[@"otherList"]];
            
        }
        [self setUp];
    }];
}
//获取亲属邻里数据
- (void)getQinQiData {
    
      NSInteger  count = [self.dataArray count];
    
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/other/getOtherList.do" params:@{@"offset":@(count),@"size":@10,@"contactType":@"2"} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [self.myScroll.mj_footer endRefreshing];
        if (showdata == nil) {
            return ;
        }
        
        if ([showdata[@"otherList"] count] == 0 && count == 0) {
            self.dataArray = [NSMutableArray array];
        } else {
            [self.dataArray addObjectsFromArray:showdata[@"otherList"]];
        }
        [self setUp];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
