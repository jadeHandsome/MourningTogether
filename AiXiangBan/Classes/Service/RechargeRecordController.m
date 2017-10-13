//
//  RechargeRecordController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RechargeRecordController.h"
#import "RechargeRecordCell.h"
@interface RechargeRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger nowCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger everyCount;
@end

@implementation RechargeRecordController

- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值记录";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    self.nowCount = 0;
    self.everyCount = 20;
    [self requestData];
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)requestData{
    NSDictionary *params = @{@"offset":@(self.nowCount),@"size":@(self.everyCount)};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/trade/base/getRechargeList.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if ([showdata[@"rechargeList"] count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
            self.totalCount = [showdata[@"totalCount"] integerValue];
            [self.data addObjectsFromArray:showdata[@"rechargeList"]];
            CGFloat height = self.data.count * 45 < SIZEHEIGHT - navHight - 20 ? self.data.count * 45 : SIZEHEIGHT - navHight - 20;
            self.tableView.frame = CGRectMake(10, navHight + 10, SIZEWIDTH - 20, height);
            [self.tableView reloadData];
        }
    }];
}

- (void)getMoreData{
    self.nowCount += self.everyCount ;
    [self requestData];
}

- (void)setUp{
    CGFloat height = 0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, navHight + 10, SIZEWIDTH - 20, height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 45;
    LRViewBorderRadius(self.tableView, 7.5, 0, [UIColor whiteColor]);
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMoreData)];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeRecordCell"];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"RechargeRecordCell" owner:self options:nil].firstObject;
    }
    cell.timeLabel.text = self.data[indexPath.row][@"payTime"];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%g元",[self.data[indexPath.row][@"totalPrice"] floatValue]];
    return cell;
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
