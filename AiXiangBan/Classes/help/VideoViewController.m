//
//  VideoViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/17.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoTableViewCell.h"
@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, strong) NSArray *data;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"看看";
    self.pageNum = 1;
    [self setUp];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)requestData{
    NSDictionary *params = @{@"Action":@"ListMedia",@"PageSize":@(10),@"PageNumber":@(self.pageNum)};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/vod/media/searchMedia.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        [self.tableView.mj_header endRefreshing];
        if ([showdata[@"MediaList"][@"Media"] count]) {
            [self.tableView.mj_footer endRefreshing];
            self.data = showdata[@"MediaList"][@"Media"];
            [self.tableView reloadData];
        }
        else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:self options:nil].firstObject;
    }
    cell.titleLabel.text = self.data[indexPath.row][@"Title"];
    return cell;
}


- (void)setUp{
    self.topConstraint.constant = navHight + 10;
    LRViewBorderRadius(self.searchView, 10, 0, [UIColor whiteColor]);
    self.tableView.rowHeight = 160;
    [KRBaseTool tableViewAddRefreshHeader:self.tableView withTarget:self refreshingAction:@selector(reloadData)];
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMoreData)];
}

- (void)reloadData{
    self.pageNum = 1;
    [self requestData];
}

- (void)getMoreData{
    self.pageNum ++;
    [self requestData];
}


- (IBAction)search:(UITextField *)sender {
    
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
