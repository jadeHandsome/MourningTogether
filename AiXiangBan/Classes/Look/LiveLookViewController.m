//
//  LiveLookViewController.m
//  孝相伴
//
//  Created by MAC on 17/10/10.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "LiveLookViewController.h"

@interface LiveLookViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@end

@implementation LiveLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    self.topConstraint.constant = navHight + 10;
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
