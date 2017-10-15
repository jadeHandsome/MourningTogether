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
#import "DeleteDeviceViewController.h"
#import "LiveLookViewController.h"
#import "UIImageView+WebCache.h"
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
    [self requestData];
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}
//获取设备数据
- (void)requestData{
    [self showLoadingHUD];
    [EZOPENSDK getDeviceList:0 pageSize:20 completion:^(NSArray *deviceList, NSInteger totalCount, NSError *error) {
        [self hideHUD];
        self.data = deviceList;
        if(deviceList.count){
            self.tableView.hidden = NO;
            self.containerView.hidden = YES;
            self.view.backgroundColor = COLOR(242, 242, 242, 1);
            [self.tableView reloadData];
        }
        else{
            self.tableView.hidden = YES;
            self.containerView.hidden = NO;
            self.view.backgroundColor = [UIColor whiteColor];
        }
        
    }];
}

- (void)setUp{
    self.containerView.hidden = YES;
    LRViewBorderRadius(self.addBtn, 10, 0, [UIColor clearColor]);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    self.topConstraint.constant = navHight + 70;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHight, SIZEWIDTH, SIZEHEIGHT - navHight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 255.0f;
    self.tableView.backgroundColor = COLOR(242, 242, 241, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
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
    
    EZDeviceInfo *DeviceInfo = (EZDeviceInfo *)self.data[indexPath.row];
    if(DeviceInfo.status == 1){
        cell.onlineLabel.hidden = YES;
    }
    else{
        cell.onlineLabel.hidden = NO;
    }
    cell.titleLabel.text = DeviceInfo.deviceName;
    cell.image.image = [UIImage imageNamed:@"云医引导页-2"];
    cell.block = ^(){
        DeleteDeviceViewController *deleteVC = [DeleteDeviceViewController new];
        [self.navigationController pushViewController:deleteVC animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LiveLookViewController *LiveVC = [LiveLookViewController new];
    LiveVC.deviceInfo = self.data[indexPath.row];
    [self.navigationController pushViewController:LiveVC animated:YES];
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
