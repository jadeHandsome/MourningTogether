//
//  WatchXixunViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/12.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "WatchXixunViewController.h"

@interface WatchXixunViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentCiew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation WatchXixunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手表咨询";
    self.top.constant = navHight + 10;
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    LRViewBorderRadius(self.contentCiew, 5, 0, [UIColor clearColor]);
    // Do any additional setup after loading the view from its nib.
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
