//
//  MineViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/6.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "MineViewController.h"
#import "MineInfoView.h"
#import "RepareInfoViewController.h"
#import "SettingViewController.h"
@interface MineViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView *mineScrollView;//信息的scrollView
@property (nonatomic, strong) NSArray *allData;//所有的个人信息
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    self.allData = @[@{@"isImage":@"1",@"title":@"头像",@"right":@""},@{@"isImage":@"0",@"title":@"姓名",@"right":@"周春仕"},@{@"isImage":@"0",@"title":@"电话",@"right":@"18888888888"},@{@"isImage":@"0",@"title":@"性别",@"right":@"女"},@{@"isImage":@"0",@"title":@"年龄",@"right":@"80"},@{@"isImage":@"0",@"title":@"体重",@"right":@"80KG"},@{@"isImage":@"0",@"title":@"身高",@"right":@"188"}];
    [self setUP];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"云医时代-53"] style:UIBarButtonItemStyleDone target:self action:@selector(settingClick)];
    
}
- (void)settingClick {
    //跳转设置页面
    SettingViewController *setting = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)setUP {
    self.mineScrollView = [[UIScrollView alloc]init];
    self.mineScrollView.contentSize = CGSizeMake(0, 330);
    [self.view addSubview:self.mineScrollView];
    [self.mineScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    UIView *centerView = [[UIView alloc]init];
    [self.mineScrollView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@330);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.mineScrollView.mas_top).with.offset(10);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(centerView, 10, 0, [UIColor clearColor]);
    UIView *temp = centerView;
    for (int i = 0; i < 7; i ++) {
        MineInfoView *infoView = [[MineInfoView alloc]init];
        [infoView setUpWithDic:self.allData[i] withClickHandle:^{
            LRLog(@"点了第%d个",i);
            RepareInfoViewController *repare = [[RepareInfoViewController alloc]init];
            
            switch (i) {
                case 1:
                {
                    repare.title = @"姓名";
                    [self.navigationController pushViewController:repare animated:YES];
                }
                    break;
                case 2:
                {
                    repare.title = @"电话";
                    [self.navigationController pushViewController:repare animated:YES];
                }
                    break;
                case 4:
                {
                    repare.title = @"年龄";
                    [self.navigationController pushViewController:repare animated:YES];
                }
                    break;
                case 5:
                {
                    repare.title = @"体重";
                    [self.navigationController pushViewController:repare animated:YES];
                }
                    break;
                case 6:
                {
                    repare.title = @"身高";
                    [self.navigationController pushViewController:repare animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
            if (i == 0) {
                //修改头像
                [self repareHeadImage];
                //[WeakSelf repareHeadImage];
            } else if (i == 3) {
                //修改性别
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择性别" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //选择女的
                    
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //选择男的
                }];
                [alert addAction:action];
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        [centerView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView.mas_right);
            make.left.equalTo(centerView.mas_left);
            if (i == 0) {
                make.height.equalTo(@60);
                make.top.equalTo(temp.mas_top);
            } else {
                make.height.equalTo(@45);
                make.top.equalTo(temp.mas_bottom);
            }
        }];
        temp = infoView;
    }
    
    
}
- (void)repareHeadImage {
    //改头像
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
            pickerController.delegate = self;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerController animated:YES completion:nil];
        }
        
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }];
    [controller addAction:action];
    [controller addAction:action1];
    [controller addAction:action2];
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}
#pragma -- imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //UIImage *newImage = [self thumbnaiWithImage:image size:CGSizeMake(170, 110)];
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    //self.param[@"imageData"] = [[UIImage alloc]initWithData:data];
    //[self.imageArray addObject:@{self.upOrDown:data}];
    //[self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
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
