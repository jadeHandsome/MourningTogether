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
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)requestData{
    NSDictionary *params = @{@"offset":@(self.nowCount),@"size":@3};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/trade/base/getRechargeList.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if(!showdata){
            return ;
        }

        self.totalCount = [showdata[@"totalCount"] integerValue];
        [self.data addObjectsFromArray:showdata[@"rechargeList"]];
        [self setUp];
    }];
}

- (void)getMoreData{
    self.nowCount ++ ;
    [self requestData];
}

- (void)setUp{
    CGFloat height = self.data.count * 45 < SIZEHEIGHT - navHight - 20 ? self.data.count * 45 : SIZEHEIGHT - navHight - 20;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, navHight + 10, SIZEWIDTH - 20, height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 45;
    LRViewBorderRadius(tableView, 7.5, 0, [UIColor whiteColor]);
    [KRBaseTool tableViewAddRefreshFooter:tableView withTarget:self refreshingAction:@selector(getMoreData)];
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
    RechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeRecordCell"];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"RechargeRecordCell" owner:self options:nil].firstObject;
    }
    cell.timeLabel.text = self.data[indexPath.row][@"payTime"];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%g",[self.data[indexPath.row][@"totalPrice"] floatValue]];
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
