//
//  AccountViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/7.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"孝心币";
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    LRViewBorderRadius(self.topContainer, 10, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.bottomContainer, 10, 0, [UIColor clearColor]);
    LRViewBorderRadius(self.headImage, 25, 5, ColorRgbAValue(0xffffff, 0.5));
    self.topConstraint.constant = navHight;
}


- (IBAction)recharge:(UITapGestureRecognizer *)sender {
}
- (IBAction)record:(UITapGestureRecognizer *)sender {
}
- (IBAction)bill:(UITapGestureRecognizer *)sender {
}
- (IBAction)service:(UITapGestureRecognizer *)sender {
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
