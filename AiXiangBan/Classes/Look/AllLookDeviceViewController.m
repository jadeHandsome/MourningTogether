//
//  AllLookDeviceViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/16.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AllLookDeviceViewController.h"
#import "AllDeviceCell.h"
@interface AllLookDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectNum;

@end

@implementation AllLookDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所以设备";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    self.selectNum = -1;
    [self setUp];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData{
    NSDictionary *params = @{@"deviceType":@2,@"offset":@0,@"size":@10};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/device/getDeviceList.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            self.data = showdata[@"deviceList"];
            [self.tableView reloadData];
        }
    }];
}


- (void)setUp{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHight, SIZEWIDTH, SIZEHEIGHT - navHight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR(242, 242, 242, 1);
    tableView.rowHeight = 60;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllDeviceCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AllDeviceCell" owner:self options:nil].firstObject;
    }
    cell.NameLabel.text = self.data[indexPath.row][@"deviceName"];
    cell.numberLabel.text = self.data[indexPath.row][@"deviceSerialNo"];
    cell.selectBtn.selected = self.selectNum == indexPath.row ? YES : NO;
    cell.block = ^(BOOL select) {
        if (select) {
            self.selectNum = indexPath.row;
        }
        else{
            self.selectNum = -1;
        }
        [self.tableView reloadData];
    };
    return cell;
}


- (void)add{
//    [KRMainNetTool sharedKRMainNetTool]
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
