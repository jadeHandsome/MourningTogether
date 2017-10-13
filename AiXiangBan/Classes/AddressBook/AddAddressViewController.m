//
//  AddAddressViewController.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/8.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddAddressView.h"
@interface AddAddressViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView *mainScrool;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation AddAddressViewController
{
    NSInteger typeCount;
}
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBAColor(242, 242, 242, 1);
    if (!self.oldDic) {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    }
    
    if (self.type == 1) {
        typeCount = 11;
        self.navigationItem.title = @"添加老人";
    } else if (self.type == 2) {
        typeCount = 3;
        self.param[@"contactType"] = @1;
        self.navigationItem.title = @"添加监护人";
    } else {
        typeCount = 3;
        self.param[@"contactType"] = @2;
        self.navigationItem.title = @"添加亲属邻里";
    }
    if (self.oldDic) {
        [self.param addEntriesFromDictionary:self.oldDic];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseFinish) name:@"choosePhoneFinish" object:nil];
    [self setUP];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)chooseFinish {
    [self upData];
}
- (void)upData {
    for (UIView *sub in self.mainScrool.subviews) {
        for (UIView *centerSub in sub.subviews) {
            if (centerSub.tag == 1001 || centerSub.tag == 1002 || centerSub.tag == 10000 || centerSub.tag == 10001) {
                AddAddressView *addView = (AddAddressView *)centerSub;
                [addView upData:centerSub.tag];
            }
        }
    }
}
- (void)finish {
    if (self.type == 1) {
        NSArray *image = nil;
        if (self.param[@"image"]) {
            image = @[self.param[@"image"]];
        }
        if (self) {
            image = @[@{@"name":@"headImgUrl",@"data":UIImageJPEGRepresentation(_zhanweiImageData, 1)}];
        }
        self.param[@"headImgUrl"] = @"111";
        NSString *path = @"";
        if (self.oldDic) {
            path = @"/mgr/contacts/elder/editElder.do";
        } else {
            path = @"/mgr/contacts/elder/addElder.do";
        }
        [[KRMainNetTool sharedKRMainNetTool] upLoadData:path params:self.param andData:image waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [self showHUDWithText:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        NSString *path = @"";
        if (self.oldDic) {
            path = @"/mgr/contacts/other/editOther.do";
        } else {
            path = @"/mgr/contacts/other/addOther.do";
        }
        [[KRMainNetTool sharedKRMainNetTool] upLoadData:path params:self.param andData:@[self.param[@"image"]] waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata == nil) {
                return ;
            }
            [self showHUDWithText:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
}
- (void)setUP {
    self.mainScrool = [[UIScrollView alloc]init];
    [self.view addSubview:self.mainScrool];
    [self.mainScrool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(navHight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    if (self.oldDic) {
        self.mainScrool.contentSize = CGSizeMake(0, 50 + 45 * typeCount + 65 + 50);
    } else {
        self.mainScrool.contentSize = CGSizeMake(0, 50 + 45 * typeCount + 50);
        
    }
    UIView *centerView = [[UIView alloc]init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.mainScrool addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrool.mas_top).with.offset(50);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@(45 * typeCount + 50));
    }];
    LRViewBorderRadius(centerView, 5, 0, [UIColor whiteColor]);
    
    UIView *temp = centerView;
    for (int i = 0; i < typeCount; i ++) {
        AddAddressView *add = [[AddAddressView alloc]init];
        if ( i == 0 ) {
            add.tag = 1001;
        } else if (i == 1) {
            add.tag = 1002;
        }
        if (typeCount > 5) {
            if (i == 9) {
                add.tag = 10000;
            } else if (i == 10) {
                add.tag = 10001;
            }
        }
        add.superVc = self;
        [centerView addSubview:add];
        [add mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i ==0) {
                make.top.equalTo(temp.mas_top).with.offset(50);
                
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.height.equalTo(@45);
            make.left.equalTo(centerView.mas_left);
            make.right.equalTo(centerView.mas_right);
        }];
        [add setUpWithTag:i + 1 andParam:self.param andType:self.type];
        temp = add;
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.mainScrool addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrool.mas_top).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@75);
        make.height.equalTo(@75);
    }];
    imageView.image = [UIImage imageNamed:@"孝相伴-27"];
    self.headImageView = imageView;
    LRViewBorderRadius(imageView, 37.5, 0, [UIColor clearColor]);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(addImage)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    if (self.oldDic) {
        UIButton *deletBtn = [[UIButton alloc]init];
        [self.mainScrool addSubview:deletBtn];
        [deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_bottom).with.offset(10);
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.height.equalTo(@45);
        }];
        deletBtn.backgroundColor =LRRGBColor(211, 80, 70);
        [deletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deletBtn setTitle:@"删除" forState:UIControlStateNormal];
        LRViewBorderRadius(deletBtn, 5, 0, [UIColor clearColor]);
        [deletBtn addTarget:self action:@selector(delectClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
//删除
- (void)delectClick {
    //删除
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除联系人" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
        if (self.type == 1) {
            [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/elder/deleteElder.do" params:@{@"elderId":self.oldDic[@"elderId"]} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
                if (showdata == nil) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"删除成功"];
            }];
        } else {
            [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/contacts/other/deleteOther.do" params:@{@"elderId":self.oldDic[@"otherId"]} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
                if (showdata == nil) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"删除成功"];
            }];
        }
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
        
    }];
   
    [controller addAction:action];
    [controller addAction:action1];
    
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}
- (void)addImage {
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
    self.param[@"image"] = @{@"name":@"headImgUrl",@"data":data};
    self.headImageView.image = image;
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
