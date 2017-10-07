//
//  BillViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BillViewController.h"
#import "BillCell.h"
@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *data;

@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值记录";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    self.data = @[@{@"time":@"2016-12-30 08:30:30",@"price":@"100元",@"text":@"通讯服务卡"},@{@"time":@"2016-12-30 08:30:30",@"price":@"50元",@"text":@"通讯服务卡"},@{@"time":@"2016-12-30 08:30:30",@"price":@"60元",@"text":@"通讯服务卡"},@{@"time":@"2016-12-30 08:30:30",@"price":@"88元",@"text":@"通讯服务卡"}];
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)setUp{
    CGFloat height = self.data.count * 80 < SIZEHEIGHT - navHight - 20 ? self.data.count * 80 : SIZEHEIGHT - navHight - 20;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, navHight + 10, SIZEWIDTH - 20, height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 80;
    LRViewBorderRadius(tableView, 7.5, 0, [UIColor whiteColor]);
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
    cell.timeLabel.text = self.data[indexPath.row][@"time"];
    cell.detailLabel.text = self.data[indexPath.row][@"text"];
    cell.priceLabel.text = self.data[indexPath.row][@"price"];
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
