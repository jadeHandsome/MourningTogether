//
//  BillViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BillViewController.h"
#import "BillCell.h"
#import "BillDetailViewController.h"
@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger nowCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger everyCount;
@end

@implementation BillViewController

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"缴费记录";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    self.nowCount = 0;
    self.everyCount = 20;
    [self requestData];
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)requestData{
    NSDictionary *params = @{@"offset":@(self.nowCount),@"size":@(self.everyCount)};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/trade/base/getConsumeList.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if ([showdata[@"consumeList"] count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
            self.totalCount = [showdata[@"totalCount"] integerValue];
            [self.data addObjectsFromArray:showdata[@"consumeList"]];
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
    tableView.rowHeight = 90;
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
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell"];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"BillCell" owner:self options:nil].firstObject;
    }
    cell.timeLabel.text = [self changeTimeStr:self.data[indexPath.row][@"createdTime"]];
//    cell.detailLabel.text = self.data[indexPath.row][@"text"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%g元",[self.data[indexPath.row][@"totalPrice"] floatValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BillDetailViewController *detailVC = [BillDetailViewController new];
    detailVC.consumeContent = self.data[indexPath.row][@"consumeContent"];
    detailVC.price = [self.data[indexPath.row][@"totalPrice"] floatValue];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSString *)changeTimeStr:(NSString *)str{
    NSString *year = [str substringToIndex:4];
    NSString *month = [str substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [str substringWithRange:NSMakeRange(6, 2)];
    NSString *hour = [str substringWithRange:NSMakeRange(8, 2)];
    NSString *min = [str substringWithRange:NSMakeRange(10, 2)];
    NSString *sec = [str substringWithRange:NSMakeRange(12, 2)];
    NSString *time = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,min,sec];
    return time;
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
