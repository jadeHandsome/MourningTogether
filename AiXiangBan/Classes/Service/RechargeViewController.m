//
//  RechargeViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeCell.h"
#import "ConfirmViewController.h"

@interface RechargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, assign) NSInteger ChooseNum;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *productIds;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *payMoney;
@end

@implementation RechargeViewController

- (NSArray *)productIds{
    if (!_productIds) {
        _productIds = @[@"040",@"073",@"148"];
    }
    return _productIds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    self.data = @[@{@"price":@"25",@"bottomPrice":@"40"},@{@"price":@"50",@"bottomPrice":@"73"},@{@"price":@"100",@"bottomPrice":@"148"}];
    self.ChooseNum = self.data.count;
    [self setUp];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    UIButton *rechargeBtn = [[UIButton alloc] init];
    [rechargeBtn setBackgroundColor:ColorRgbValue(0x1cb9cf)];
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(rechargeBtn, 10, 0, ColorRgbValue(0x1cb9cf));
    [rechargeBtn addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-10);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@45);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = [UIFont systemFontOfSize:18];
    phoneLabel.textColor = ColorRgbValue(0x333333);
    phoneLabel.text = SharedUserInfo.mobile;
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(navHight + 15);
        make.left.equalTo(self.view).with.offset(10);
    }];
    
    //添加collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 15;
    [flowLayout setItemSize:CGSizeMake( ( SIZEWIDTH - 40 )  / 3 ,  50)];//设置cell的尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerNib:[UINib nibWithNibName:@"RechargeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RechargeCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    CGFloat height = self.data.count % 3 == 0 ? (self.data.count / 3) * 50 + (self.data.count / 3 - 1) * 15 : (self.data.count / 3 + 1) * 50 + self.data.count / 3 * 15;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(height));
    }];
//
//    UIView *inputContainer = [[UIView alloc] init];
//    inputContainer.backgroundColor = ColorRgbValue(0xf2f2f2);
//    LRViewBorderRadius(inputContainer, 7.5, 0, ColorRgbValue(0xf2f2f2));
//    [self.view addSubview:inputContainer];
//    [inputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(collectionView.mas_bottom).with.offset(15);
//        make.left.equalTo(self.view).with.offset(10);
//        make.right.equalTo(self.view).with.offset(-10);
//        make.height.equalTo(@(45));
//    }];
//
//    UILabel *qitaLabel = [[UILabel alloc] init];
//    qitaLabel.font = [UIFont systemFontOfSize:16];
//    qitaLabel.textColor = ColorRgbValue(0x989898);
//    qitaLabel.text = @"其它金额：";
//    [inputContainer addSubview:qitaLabel];
//    [qitaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(inputContainer).with.offset(10);
//        make.centerY.equalTo(inputContainer.mas_centerY);
//        make.width.equalTo(@90);
//    }];
//
//    UITextField *textField = [[UITextField alloc] init];
//    textField.textColor = ColorRgbValue(0x989898);
//    textField.font = [UIFont systemFontOfSize:16];
//    textField.placeholder = @"请输入10~500的整数";
//    textField.keyboardType = UIKeyboardTypeNumberPad;
//    textField.textAlignment = NSTextAlignmentLeft;
//    [textField addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
//    [inputContainer addSubview:textField];
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(qitaLabel.mas_right).with.offset(10);
//        make.top.equalTo(inputContainer);
//        make.right.equalTo(inputContainer);
//        make.bottom.equalTo(inputContainer);
//    }];
//    self.textField = textField;
    
    UILabel *price = [[UILabel alloc] init];
    price.font = [UIFont systemFontOfSize:18];
    price.textColor = ColorRgbValue(0xf46b20);
    price.text = @"实际付款：";
    [self.view addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(10);
    }];
    self.priceLabel = price;
    
    UILabel *balance = [[UILabel alloc] init];
    balance.font = [UIFont systemFontOfSize:16];
    balance.textColor = ColorRgbValue(0x333333);
    balance.text = [NSString stringWithFormat:@"余额：%@",SharedUserInfo.balance];
    [self.view addSubview:balance];
    [balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(10);
    }];
}

#pragma mark ------------- UICollectionView -------------------
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RechargeCell *cell = (RechargeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RechargeCell" forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@元",self.data[indexPath.item][@"price"]];
    cell.detailLabel.text = [NSString stringWithFormat:@"售价：%@元",self.data[indexPath.item][@"bottomPrice"]];
    cell.isChoose = indexPath.item == self.ChooseNum ? YES : NO;
    return cell;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.ChooseNum = indexPath.item;
    self.priceLabel.text = [NSString stringWithFormat:@"实际付款：%@元",self.data[indexPath.item][@"bottomPrice"]];
    self.productId = self.productIds[indexPath.item];
    self.payMoney = self.data[indexPath.item][@"bottomPrice"];
    [self.collectionView reloadData];
}

- (void)textfieldChange:(UITextField *)textField{
    self.ChooseNum = self.data.count;
    self.priceLabel.text = [NSString stringWithFormat:@"实际付款：%@元",textField.text];
    [self.collectionView reloadData];
}
//充值
- (void)recharge{
    if (self.productId == nil) {
        [self showHUDWithText:@"请选择充值金额"];
    }
    else{
        ConfirmViewController *confirm = [ConfirmViewController new];
        confirm.productId = self.productId;
        confirm.payMoney = self.payMoney;
        [self.navigationController pushViewController:confirm animated:YES];
    }
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
