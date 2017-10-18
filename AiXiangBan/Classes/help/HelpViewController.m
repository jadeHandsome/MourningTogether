//
//  HelpViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HelpViewController.h"
#import "QYSource.h"
#import "QYSessionViewController.h"
#import "QYSDK.h"
#import "VideoViewController.h"
@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UIView *gradientView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮帮";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
    [self hideNaviBar];
    [self gradient];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self showNaviBar];
}

//渐变
- (void)gradient{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)ColorRgbValue(0x1cb9cf).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, SIZEWIDTH, SIZEHEIGHT * 0.5);
    [self.gradientView.layer addSublayer:gradientLayer];
}

- (IBAction)yangsheng:(UITapGestureRecognizer *)sender {
    VideoViewController *video = [VideoViewController new];
    [self.navigationController pushViewController:video animated:YES];
}
- (IBAction)yiliao:(UITapGestureRecognizer *)sender {
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"医疗";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
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
