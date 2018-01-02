//
//  ConfirmViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "ConfirmViewController.h"
#import<StoreKit/StoreKit.h>
@interface ConfirmViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, strong) SKProductsRequest *request;

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    LRViewBorderRadius(self.topView, 7.5, 0, [UIColor whiteColor]);
    LRViewBorderRadius(self.confirmBtn, 7.5, 0, [UIColor clearColor]);
    self.topConstraint.constant = navHight + 10;
    self.phoneLabel.text = [KRUserInfo sharedKRUserInfo].mobile;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",self.payMoney];
    self.realPriceLabel.text = [NSString stringWithFormat:@"%@元",self.payMoney];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)confirm:(UIButton *)sender {
    [self showLoadingHUDWithText:@"充值中..."];
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:self.productId];
    }
    else{
        [self showHUDWithText:@"内购发生错误"];
    }
}

- (void)requestProductData:(NSString *)productId{
    NSSet *nsset = [NSSet setWithObjects:productId, nil];
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    self.request.delegate = self;
    [self.request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
    if (products.count == 0) {
        [self showHUDWithText:@"内购发生错误"];
        return;
    }
    NSLog(@"productId%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量%lu",products.count);
    SKProduct *product = nil;
    for (SKProduct *pro in products) {
        NSLog(@"%@",pro.description);
        NSLog(@"%@",pro.localizedTitle);
        NSLog(@"%@",pro.localizedDescription);
        NSLog(@"%@",pro.price);
        NSLog(@"%@",pro.productIdentifier);
        if ([pro.productIdentifier isEqualToString:self.productId]) {
            product = pro;
        }
    }
    if (product != nil) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        NSLog(@"发送购买请求");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        [self showHUDWithText:@"内购发生错误"];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self showHUDWithText:@"充值失败"];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        NSLog(@"打印错误日志%@",tran.error.description);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            default:
                [self hideHUD];
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transcation{
    NSLog(@"%@",transcation.payment.productIdentifier);
    NSString *result = [[NSString alloc] initWithData:transcation.transactionReceipt encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"memberId":SharedUserInfo.memberId,@"memberName":SharedUserInfo.memberName,@"totalFee":self.money,@"receipt":result,@"chooseEnv":@(YES)};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/trade/iap/setIapCertificate.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            if ([showdata[@"success"] boolValue]) {
                [self showHUDWithText:@"充值成功"];
                [self performSelector:@selector(popOutAction) withObject:nil afterDelay:1.0];
            }
        }
    }];
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
