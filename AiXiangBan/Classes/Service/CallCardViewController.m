//
//  CallCardViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/13.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "CallCardViewController.h"
#import "CallCardCell.h"
#import "CallCardDetailViewController.h"
@interface CallCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger nowCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger everyCount;

@end

@implementation CallCardViewController
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯卡服务";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    self.nowCount = 0;
    self.everyCount = 20;
    [self requestData];
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)requestData{
    NSDictionary *params = @{@"offset":@(self.nowCount),@"size":@(self.everyCount)};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/trade/base/getSimList.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if ([showdata[@"simList"] count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
            self.totalCount = [showdata[@"totalCount"] integerValue];
            [self.data addObjectsFromArray:showdata[@"simList"]];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)getMoreData{
    self.nowCount += self.everyCount ;
    [self requestData];
}

- (void)setUp{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHight, SIZEWIDTH, SIZEHEIGHT - navHight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 110;
    tableView.backgroundColor = COLOR(242, 242, 242, 1);
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMoreData)];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CallCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallCardCell"];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"CallCardCell" owner:self options:nil].firstObject;
    }
    cell.nameLabel.text = self.data[indexPath.row][@"elderName"];
    cell.numberLabel.text = self.data[indexPath.row][@"simMsisdn"];
    cell.cardNameLabel.text = self.data[indexPath.row][@"packageList"][0][@"packageName"];
    NSInteger switchStatus = [self.data[indexPath.row][@"switchStatus"] integerValue];
    NSString *simIccid = self.data[indexPath.row][@"simIccid"];
    [cell.button setTitle:switchStatus == 0 ? @"开通":@"停止" forState:UIControlStateNormal];
    __weak __typeof(self) weakSelf = self;
    cell.switchBlock = ^(){
        [weakSelf openOrClose:switchStatus simIccid:simIccid];
    };
    cell.detailBlock = ^(){
        CallCardDetailViewController *detail = [CallCardDetailViewController new];
        detail.package = weakSelf.data[indexPath.row][@"packageList"][0];
        [weakSelf.navigationController pushViewController:detail animated:YES];
    };
    return cell;
}

- (void)openOrClose:(NSInteger)state simIccid:(NSString *)simIccid{
    NSString *url = @"";
    NSDictionary *params = @{@"simIccid" : simIccid};
    if (state == 1) {
        url = @"/trade/base/stopSimService.do";
    }
    else{
        url = @"/trade/base/startSimService.do";
    }
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:url params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        self.nowCount = 0;
        [self.data removeAllObjects];
        [self requestData];
    }];
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
