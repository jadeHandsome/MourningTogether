//
//  KRShengTableViewController.m
//  Dntrench
//
//  Created by kupurui on 16/10/20.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRShengTableViewController.h"
#import "KRMainNetTool.h"
#import "MBProgressHUD+KR.h"
@interface KRShengTableViewController ()
@property (nonatomic, strong) NSArray *allCityArray;
@end

@implementation KRShengTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    if (self.titleStr) {
        self.navigationItem.title = self.titleStr;
    } else {
        self.navigationItem.title = @"选择省份";
    }

}
- (void)loadData {
    NSString *path = @"Home/Base/getProvince";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (_provinceid) {
        param[@"provinceid"] = _provinceid;
        path = @"Home/Base/getCitys";
    }
    if (_city) {
        param[@"cityid"] = _city;
        path = @"Home/Base/getDistrict";
    }
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:path params:param withModel:nil complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            [MBProgressHUD showError:error];
            return ;
        }
        [(NSArray *)showdata writeToFile:@"/Users/zenghonglei/Desktop/p.txt" atomically:YES];
        self.allCityArray = [showdata copy];
        [self.tableView reloadData];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allCityArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = 0;
    }
    NSString *key = @"provincename";
    if (_provinceid) {
        key = @"cityname";
    }
    if (_city) {
        key = @"districtname";
    }
    cell.textLabel.text = self.allCityArray[indexPath.row][key];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.allCityArray[indexPath.row];
    KRShengTableViewController *vc = [[KRShengTableViewController alloc]init];
    if (_provinceid == nil && _city == nil) {
        vc.provinceid = dic[@"provinceid"];
        vc.selectedAddress = [@{@"provinceid":dic[@"provinceid"]} mutableCopy];
        vc.selectedStr = [dic[@"provincename"] stringByAppendingString:@" "];
        vc.titleStr = dic[@"provincename"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_provinceid != nil) {
        vc.city = dic[@"cityid"];
        vc.selectedAddress = [@{@"provinceid":self.selectedAddress[@"provinceid"],@"cityid":dic[@"cityid"]} mutableCopy];
        vc.selectedStr = [self.selectedStr stringByAppendingFormat:@"%@ ",dic[@"cityname"]];
        vc.titleStr = dic[@"cityname"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        self.selectedAddress[@"districtid"] = dic[@"districtid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedAddress" object:@[self.selectedAddress,[self.selectedStr stringByAppendingFormat:@"%@",dic[@"districtname"]]]];
        UIViewController *vc1 = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 4];
        [self.navigationController popToViewController:vc1 animated:YES];
    }
    
}

@end
