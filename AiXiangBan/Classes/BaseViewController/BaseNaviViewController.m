//
//  BaseNaviViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseNaviViewController.h"

@interface BaseNaviViewController ()<UIGestureRecognizerDelegate>


@end

@implementation BaseNaviViewController

+ (void)load{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.shadowImage=[UIImage new];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setBarTintColor:ColorRgbValue(0x1cb9cf)];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - - orientation
//设置是否允许自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.interfaceOrientationMask;
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.interfaceOrientation;
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
