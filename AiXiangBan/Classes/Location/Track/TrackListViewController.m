//
//  TrackListViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/18.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TrackListViewController.h"
#import "TrackTableViewCell.h"

@interface TrackListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabbleView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *datelabel;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableArray *allPoint;

@end

@implementation TrackListViewController
{
    NSInteger count;
}

- (NSMutableArray *)allPoint {
    if (!_allPoint) {
        _allPoint = [NSMutableArray array];
        
    }
    return _allPoint;
}
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
   
//    self.param[@"beginTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd000000" withDate:[NSDate date]];
//    self.param[@"endTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMddHHmmss" withDate:[NSDate date]];
    count = 0;
    [self setUp];
    [self setUpTab];
    self.navigationController.navigationItem.title = @"足迹";
    
}

- (void)viewWillAppear:(BOOL)animated {
    UIButton *sender = [self.titleView viewWithTag:self.currentDay];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 * (self.currentDay - 100) sinceDate:[NSDate date]];//前一天
    NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60 * (self.currentDay - 101) sinceDate:[NSDate date]];//后一天
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"yyyy/MM/dd EEEE";
    NSString *dateStr = [dateFormater stringFromDate:lastDay];
    
    self.datelabel.text = dateStr;
    
    
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView.mas_left).with.offset((SCREEN_WIDTH - 2)/7 * (sender.tag - 100));
        }];
        
    } completion:^(BOOL finished) {
        [sender setSelected:YES];
        [self.allPoint removeAllObjects];
        self.param[@"beginTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd000000" withDate:lastDay];
        self.param[@"endTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd000000" withDate:nextDay];
        [weakSelf loadD];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUp {
    UIView *dateView = [[UIView alloc]init];
    [self.view addSubview:dateView];
    [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
    }];
    UILabel *dateLabel = [[UILabel alloc]init];
    _datelabel = dateLabel;
    [dateView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateView.mas_left).with.offset(10);
        make.centerY.equalTo(dateView.mas_centerY);
        
    }];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"yyyy/MM/dd EEEE";
    
    NSString *dateStr = [dateFormater stringFromDate:date];
    
    dateLabel.text = dateStr;
    
    dateLabel.textColor = LRRGBColor(29, 185, 207);
    dateLabel.font = [UIFont systemFontOfSize:15];
    UIView *titleView = [[UIView alloc]init];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    UIView *temp = titleView;
    _titleView = titleView;
    for (int i = 0; i < 7; i ++) {
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
            make.width.equalTo(@((SCREEN_WIDTH - 2)/7));
        }];
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(147, 147, 147) forState:UIControlStateNormal];
        [titleBtn setTitleColor:LRRGBColor(85, 183, 204) forState:UIControlStateSelected];
        titleBtn.tag = i + 100;
        temp = titleBtn;
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
        make.width.equalTo(@((SCREEN_WIDTH - 2)/7));
    }];
    bottomLine.backgroundColor = LRRGBColor(85, 183, 204);
    
}
- (void)setUpTab {
    self.tabbleView = [[UITableView alloc]init];
    [self.view addSubview:self.tabbleView];
    self.tabbleView.delegate  = self;
    self.tabbleView.dataSource = self;
    
    self.tabbleView.tableFooterView = [UIView new];
    [KRBaseTool tableViewAddRefreshFooter:self.tabbleView withTarget:self refreshingAction:@selector(loadMore)];
    [KRBaseTool tableViewAddRefreshHeader:self.tabbleView withTarget:self refreshingAction:@selector(loadD)];
    [self.tabbleView registerNib:[UINib nibWithNibName:@"TrackTableViewCell" bundle:nil] forCellReuseIdentifier:@"trakCell"];
    [self.tabbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    
}
#pragma -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allPoint.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trakCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUpWith:self.allPoint[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)titleClick:(UIButton *)sender {
    for (UIView *sub in self.titleView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            [btn setSelected:NO];
        }
    }
    NSDate * date = [NSDate date];//当前时间
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 * (sender.tag - 100) sinceDate:date];//前一天
    //NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"yyyy/MM/dd EEEE";
    NSString *dateStr = [dateFormater stringFromDate:lastDay];
    
    self.datelabel.text = dateStr;
    
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView.mas_left).with.offset((SCREEN_WIDTH - 2)/7 * (sender.tag - 100));
        }];
        
    } completion:^(BOOL finished) {
        [sender setSelected:YES];
        [self.allPoint removeAllObjects];
        self.param[@"beginTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMdd000000" withDate:lastDay];
        self.param[@"endTime"] = [KRBaseTool timeStringFromFormat:@"yyyyMMddHHmmss" withDate:lastDay];
        [weakSelf loadD];
    }];
    
}
- (void)loadD {
    count = 0;
    [self.allPoint removeAllObjects];
    [self loadData];
}
- (void)loadMore {
    count = self.allPoint.count;
    [self loadData];
}
- (void)loadData {
    
    self.param[@"offset"] = @(count);
    self.param[@"size"] = @(30);
    self.param[@"deviceId"] = [KRUserInfo sharedKRUserInfo].deviceSn;
    [[KRMainNetTool sharedKRMainNetTool]sendRequstWith:@"/device/getFootmarkList.do" params:self.param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [self.tabbleView.mj_header endRefreshing];
        [self.tabbleView.mj_footer endRefreshing];
        if (showdata == nil) {
            return ;
        }
        
        NSArray *list = showdata[@"footmarkList"];
        [self.allPoint addObjectsFromArray:list];
        [self.tabbleView reloadData];
        
        
    }];
     
}
@end
