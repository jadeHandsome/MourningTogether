//
//  LookViewController.m
//  孝相伴
//
//  Created by MAC on 17/10/9.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LookViewController.h"
#import "LookCell.h"
#import "AddByQRCodeViewController.h"

@interface LookViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@end

@implementation LookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"看看";
    self.data = @[];
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    LRViewBorderRadius(self.addBtn, 10, 0, [UIColor clearColor]);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    if (self.data.count) {
        self.containerView.hidden = YES;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHight, SIZEWIDTH, SIZEWIDTH - navHight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 255.0f;
        self.tableView.backgroundColor = COLOR(242, 242, 241, 1);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }
    else{
        self.topConstraint.constant = navHight + 70;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LookCell" owner:self options:nil].firstObject;
    }
    cell.titleLabel.text = self.data[indexPath.row][@"title"];
    cell.block = ^(){
        
    };
    return cell;
}
- (IBAction)addAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"添加新设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AddByQRCodeViewController *QRCodeVC = [AddByQRCodeViewController new];
        [self.navigationController pushViewController:QRCodeVC animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"添加原来已有的设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
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
