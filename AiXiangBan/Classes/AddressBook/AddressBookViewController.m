//
//  AddressBookViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddressBookViewController.h"
#import "TYTabButtonPagerController.h"
#import "AddressView.h"
#import "AddAddressViewController.h"
@interface AddressBookViewController ()<UISearchBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *sortArray;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *bottomLine;//下面滑动的那条线
@property (nonatomic, strong) UIScrollView *bottomScro;//下面装三个view
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIScrollView *oldScr;
@property (nonatomic, strong) UIScrollView *jianhuScr;
@property (nonatomic, strong) UIScrollView *qinQScr;
@property (nonatomic, strong) NSString *searchStr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIView *oldView;
@property (nonatomic, strong) UIView *jianhuView;
@property (nonatomic, strong) UIView *qinqiView;
@end

@implementation AddressBookViewController
{
    NSArray *tempArray;
    NSInteger olderNum;
    NSInteger jianhuNum;
    NSInteger qinqiNum;
}
- (void)setSearchStr:(NSString *)searchStr {
    _searchStr = searchStr;
    
    [self layOutSubs:searchStr];
    
    
}
- (void)layOutSubs:(NSString *)search {
    [self reSet];
    if (search.length == 0) {
        return;
    }
    if (self.type == 1) {
        NSArray *array = [self.dataArray[0] copy];
        for (NSDictionary *dic in array) {
            if (![dic[@"elderName"] containsString:search] && ![dic[@"mobile"] containsString:search]) {
                NSInteger index = [array indexOfObject:dic] + 1000;
                AddressView *add = [self.oldView viewWithTag:index];
                [add mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                add.hidden = YES;
            }
        }
    } else if (self.type == 2) {
        NSArray *array = [self.dataArray[1] copy];
        for (NSDictionary *dic in array) {
            if (![dic[@"otherName"] containsString:search] && ![dic[@"mobile"] containsString:search]) {
                NSInteger index = [array indexOfObject:dic] + 1000;
                AddressView *add = [self.jianhuView viewWithTag:index];
                [add mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                add.hidden = YES;
            }
        }
    } else {
        NSArray *array = [self.dataArray[2] copy];
        for (NSDictionary *dic in array) {
            if (![dic[@"otherName"] containsString:search] && ![dic[@"mobile"] containsString:search]) {
                NSInteger index = [array indexOfObject:dic] + 1000;
                AddressView *add = [self.qinqiView viewWithTag:index];
                [add mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                add.hidden = YES;
            }
        }
    }
    
}
- (void)reSet {
    for (UIView *sub in self.oldView.subviews) {
        if ([sub isKindOfClass:[AddressView class]]) {
            AddressView *add = (AddressView *)sub;
            [add mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
            }];
            add.hidden = NO;
        }
    }
    for (UIView *sub in self.qinqiView.subviews) {
        if ([sub isKindOfClass:[AddressView class]]) {
            AddressView *add = (AddressView *)sub;
            [add mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
            }];
            add.hidden = NO;
        }
    }
    for (UIView *sub in self.jianhuView.subviews) {
        if ([sub isKindOfClass:[AddressView class]]) {
            AddressView *add = (AddressView *)sub;
            [add mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
            }];
            add.hidden = NO;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortArray = @[@"老人",@"监护人",@"亲属邻里"];
    self.navigationItem.title = @"通讯录";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"云医时代1-27"] style:UIBarButtonItemStyleDone target:self action:@selector(addClick)];
    self.type = 1;
    [self setUpPage];
    
    //[self setUpScro];
}
- (void)viewWillAppear:(BOOL)animated {
    olderNum = 0;
    jianhuNum = 0;
    qinqiNum = 0;
    [self getOld];
    [self getJianhu];
    [self getQinqi];
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:[NSMutableArray new]];
        [_dataArray addObject:[NSMutableArray new]];
        [_dataArray addObject:[NSMutableArray new]];
    }
    return _dataArray;
}
//添加L联系人
- (void)addClick {
    AddAddressViewController *add = [[AddAddressViewController alloc]init];
    NSInteger type = 1;
    for (UIView *sub in self.titleView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn.selected) {
                type = btn.tag - 99;
                
            }
        }
    }
    add.type = type;
    
    [self.navigationController pushViewController:add animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchStr = searchBar.text;
}
- (void)setUpPage {
    UIView *titleView = [[UIView alloc]init];
    _titleView = titleView;
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    UIView *temp = titleView;
    for (int i = 0; i < 3; i ++) {
        UIButton *titleBtn = [[UIButton alloc]init];
        
        [titleView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_left);
            } else {
                make.left.equalTo(temp.mas_right);
            }
            make.top.equalTo(titleView.mas_top);
            make.bottom.equalTo(titleView.mas_bottom);
            make.width.equalTo(@((SCREEN_WIDTH - 2)*0.3333));
        }];
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:self.sortArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(147, 147, 147) forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(85, 183, 204) forState:UIControlStateSelected];
        titleBtn.tag = i + 100;
        if (i < 2) {
            UIView *line = [[UIView alloc]init];
            [titleView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleBtn.mas_right);
                make.width.equalTo(@1);
                make.height.equalTo(@22);
                make.centerY.equalTo(titleView.mas_centerY);
            }];
            line.backgroundColor =LRRGBColor(147, 147, 147);
            temp = line;
        }
        if (i == 0) {
            [titleBtn setSelected:YES];
        }
        
    }
    UIView *bottomLine = [[UIView alloc]init];
    [titleView addSubview:bottomLine];
    _bottomLine = bottomLine;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.bottom.equalTo(titleView.mas_bottom);
        make.height.equalTo(@1);
        make.width.equalTo(@((SCREEN_WIDTH - 2)*0.3333));
    }];
    bottomLine.backgroundColor = LRRGBColor(85, 183, 204);
    self.searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@35);
    }];
    self.searchBar.placeholder = @"搜索";
    LRViewBorderRadius(self.searchBar, 5, 0, [UIColor clearColor]);
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];

}
- (void)titleClick:(UIButton *)sender {
    [self reSet];
    for (UIView *sub in self.titleView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            [btn setSelected:NO];
        }
    }
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView.mas_left).with.offset((SCREEN_WIDTH - 2)*0.3333 * (sender.tag - 100));
        }];
        self.bottomScro.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 100), 0);
        self.type = sender.tag - 99;
    } completion:^(BOOL finished) {
        [sender setSelected:YES];
    }];
    
}
- (void)setUpScro {
    if (self.dataArray.count < 3) {
        return;
    }
    for (UIView *sub in self.bottomScro.subviews) {
        [sub removeFromSuperview];
    }
    if (!self.bottomScro) {
        self.bottomScro = [[UIScrollView alloc]init];
    }
    
    
    
    [self.view addSubview:self.bottomScro];
    self.bottomScro.delegate = self;
    [self.bottomScro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.searchBar.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.bottomScro.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.bottomScro.showsVerticalScrollIndicator = NO;
    self.bottomScro.showsHorizontalScrollIndicator = NO;
    self.bottomScro.pagingEnabled = YES;
    UIView *temp = self.bottomScro;
    for (int i = 0; i < 3; i ++) {
        UIView *subView = [[UIView alloc]init];
        
        subView.backgroundColor = [UIColor clearColor];
        [self.bottomScro addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_left);
            } else {
                make.left.equalTo(temp.mas_right);
            }
            make.top.equalTo(self.searchBar.mas_bottom).with.offset(10);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        UIScrollView *subS = [[UIScrollView alloc]init];
        [subView addSubview:subS];
        [subS mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subView.mas_top);
            make.left.equalTo(subView.mas_left).with.offset(10);
            make.right.equalTo(subView.mas_right).with.offset(-10);
            make.bottom.equalTo(subView.mas_bottom).with.offset(-10);
        }];
        subS.backgroundColor = [UIColor clearColor];
        
        subS.contentSize = CGSizeMake(0, [self.dataArray[i] count] * 60);
        if (i == 0) {
            _oldScr = subS;
            [KRBaseTool tableViewAddRefreshHeader:subS withTarget:self refreshingAction:@selector(getOld)];
            [KRBaseTool tableViewAddRefreshFooter:subS withTarget:self refreshingAction:@selector(getOldMore)];
        } else if (i == 1) {
            _jianhuScr = subS;
            [KRBaseTool tableViewAddRefreshHeader:subS withTarget:self refreshingAction:@selector(getJianhu)];
            [KRBaseTool tableViewAddRefreshFooter:subS withTarget:self refreshingAction:@selector(getJinhuMore)];
        } else {
            _qinQScr = subS;
            [KRBaseTool tableViewAddRefreshHeader:subS withTarget:self refreshingAction:@selector(getQinqi)];
            [KRBaseTool tableViewAddRefreshFooter:subS withTarget:self refreshingAction:@selector(getMoreQinqi)];
        }
        
        UIView *secondView = [[UIView alloc]init];
        if (i == 0) {
            self.oldView = secondView;
        } else if (i == 1) {
            self.jianhuView = secondView;
        } else {
            self.qinqiView = secondView;
        }
        secondView.backgroundColor = [UIColor whiteColor];
        [subS addSubview:secondView];
        LRViewBorderRadius(secondView, 5, 0, [UIColor clearColor]);
        [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subS.mas_top);
            make.height.equalTo(@([self.dataArray[i] count] * 60));
            make.left.equalTo(subView.mas_left).with.offset(10);
            make.right.equalTo(subView.mas_right).with.offset(-10);
        }];
        UIView *bottomTemp = secondView;
        for (int j = 0; j < [self.dataArray[i] count]; j ++) {
            AddressView *address = [[AddressView alloc]init];
            if (self.searchStr.length > 0) {
                if (self.type == 1) {
                    
                    if (![self.dataArray[i][j][@"elderName"] containsString:self.searchStr]) {
                        return;
                    }
                } else {
                    if (![self.dataArray[i][j][@"otherName"] containsString:self.searchStr]) {
                        return;
                    }
                }
            }
            [secondView addSubview:address];
            address.tag = j + 1000;
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
            address.ecBlick = ^(NSDictionary *dic) {
                [self eccept:dic];
            };
            [address setUpWithDic:self.dataArray[i][j] withClickHandle:^(id responseObject) {
                NSLog(@"%@",responseObject);
                AddAddressViewController *add = [[AddAddressViewController alloc]init];
                NSInteger type = 1;
                add.oldDic = [responseObject copy];
                for (UIView *sub in self.titleView.subviews) {
                    if ([sub isKindOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)sub;
                        if (btn.selected) {
                            type = btn.tag - 99;
                            
                        }
                    }
                }
                add.type = type;
                
                [self.navigationController pushViewController:add animated:YES];
                
            }];
            bottomTemp = address;
            
        }
        temp = subView;
    }
    
}
//接受添加
- (void)eccept:(NSDictionary *)dic {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"mgr/contacts/other/accept.do" params:@{@"otherId":dic[@"otherId"]} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        olderNum = 0;
        jianhuNum = 0;
        qinqiNum = 0;
        [self getOld];
        [self getJianhu];
        [self getQinqi];
    }];
}
#pragma -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x / SCREEN_WIDTH == 0.0) {
        UIButton *btn = [self.titleView viewWithTag:100];
        [self titleClick:btn];
        self.type = 1;
    } else if (scrollView.contentOffset.x / SCREEN_WIDTH == 1.0) {
        UIButton *btn = [self.titleView viewWithTag:101];
        [self titleClick:btn];
        self.type = 2;
    } else if (scrollView.contentOffset.x / SCREEN_WIDTH == 2.0) {
        UIButton *btn = [self.titleView viewWithTag:102];
        [self titleClick:btn];
        self.type = 3;
    }
}
#pragma -- 获取所有数据
//获取老人数据
- (void)getOldMore {
    
    if (self.dataArray.count > 2) {
        olderNum  = [self.dataArray[0] count];
    }
    [self getOldManData];
}
- (void)getOld {
    olderNum = 0;
    [self getOldManData];
}
- (void)getOldManData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/elder/getElderList.do" params:@{@"offset":@(olderNum),@"size":@10} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [_oldScr.mj_footer endRefreshing];
        [_oldScr.mj_footer endRefreshing];
        if (showdata == nil) {
            return ;
        }
        if (olderNum == 0) {
            self.dataArray[0] = [showdata[@"elderList"] mutableCopy];
        } else {
            [self.dataArray[0] addObjectsFromArray:showdata[@"elderList"]];
        }
        [self setUpScro];
    }];
}
//获取监护人数据
- (void)getJinhuMore {
    
    if (self.dataArray.count > 2) {
        jianhuNum  = [self.dataArray[1] count];
    }
    [self getJianhuData];
}
- (void)getJianhu {
    jianhuNum = 0;
    [self getJianhuData];
}
- (void)getJianhuData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/other/getOtherList.do" params:@{@"offset":@(jianhuNum),@"size":@10,@"contactType":@"1"} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [_oldScr.mj_footer endRefreshing];
        [_jianhuScr.mj_footer endRefreshing];
        if (showdata == nil) {
            return ;
        }
        if (jianhuNum == 0) {
            self.dataArray[1] = [showdata[@"otherList"] mutableCopy];
        } else {
            [self.dataArray[1] addObjectsFromArray:showdata[@"otherList"]];
        }
        [self setUpScro];
    }];
}
//获取亲属邻里数据
- (void)getMoreQinqi {
    
    if (self.dataArray.count > 2) {
        qinqiNum = [self.dataArray[2] count];
    }
    [self getQinQiData];
}
- (void)getQinqi {
    qinqiNum = 0;
    [self getQinQiData];
}
- (void)getQinQiData {
    
    
    
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/other/getOtherList.do" params:@{@"offset":@(qinqiNum),@"size":@10,@"contactType":@"2"} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [_oldScr.mj_footer endRefreshing];
        [_qinQScr.mj_footer endRefreshing];
        if (showdata == nil) {
            return ;
        }
       
        if (qinqiNum == 0) {
             self.dataArray[2] = [showdata[@"otherList"] mutableCopy];
        } else {
             [self.dataArray[2] addObjectsFromArray:showdata[@"otherList"]];
        }
        [self setUpScro];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
