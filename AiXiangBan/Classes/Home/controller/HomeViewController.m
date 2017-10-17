//
//  HomeViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "HomeViewController.h"
#import "CallPushView.h"
#import "pullView.h"
#import "HomeCollectionViewCell.h"
#import "MineViewController.h"

#import "RobotViewController.h"
#import "AddressBookViewController.h"
#import "MyViewController.h"
#import "HelpViewController.h"
#import "AskHelpViewController.h"
#import "TendViewController.h"
#import "LookViewController.h"
#import "LocationViewController.h"

#import "AddAddressViewController.h"

#import <MessageUI/MessageUI.h>

#import "NoWatchViewController.h"

#import "BaseNaviViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviTop;
@property (weak, nonatomic) IBOutlet UIButton *alarmBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *hartRateBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBth;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIView *alarmView;
@property (weak, nonatomic) IBOutlet UILabel *alarmDetail;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (nonatomic, strong) UIView *groupPullView;
@property (nonatomic, copy) NSMutableArray *linkmanArr;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *collectionContainer;
@property (nonatomic, strong) NSDictionary *curretOlder;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadImage;

@end

@implementation HomeViewController
{
    NSDictionary *tempOlder;
}
- (NSMutableArray *)linkmanArr{
    if(_linkmanArr == nil){
        _linkmanArr = [NSMutableArray array];
    }
    return _linkmanArr;
}
- (void)setCurretOlder:(NSDictionary *)curretOlder {
    _curretOlder = curretOlder;
    tempOlder = curretOlder;
    self.nameLabel.text = curretOlder[@"elderName"];
    self.detailLabel.text = curretOlder[@"nickname"];
    if (![curretOlder[@"emergency"] integerValue]) {
        //self.alarmDetail.text = @"";
        self.alarmView.hidden = YES;
    } else {
        self.alarmDetail.text = [NSString stringWithFormat:@"警报：%@",curretOlder[@"emergencyTime"]];
        
    }
    [KRUserInfo sharedKRUserInfo].elderId = curretOlder[@"elderId"];
    if (curretOlder[@"deviceList"]) {
        for (NSDictionary *dic in curretOlder[@"deviceList"]) {
            if ([dic[@"deviceType"] integerValue] == 1) {
                [KRUserInfo sharedKRUserInfo].deviceId = dic[@"deviceSn"];
            }
        }
        
    } else {
        [KRUserInfo sharedKRUserInfo].deviceId = nil;
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.curretOlder[@"headImgUrl"]] placeholderImage:_zhanweiImageData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self adjustFrame];
    [self configCollectionView];
    
    LRViewBorderRadius(self.myHeadImage, 12.5, 0, [UIColor clearColor]);
    // Do any additional setup after loading the view from its nib.
}
//获取首页数据
- (void)getHomeData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/homepage/getElderList.do" params:@{@"offset":@(0),@"size":@"20"} withModel:nil complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        self.linkmanArr = [showdata[@"elderList"] mutableCopy];
        if (!self.curretOlder && [showdata[@"elderList"] count] > 0) {
            self.curretOlder = showdata[@"elderList"][0];
        } 
        [self.collectionView reloadData];
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [self getHomeData];
    [self hideNaviBar];
    self.curretOlder = tempOlder;
    [self.myHeadImage sd_setImageWithURL:[NSURL URLWithString:[KRUserInfo sharedKRUserInfo].headImgUrl] placeholderImage:_zhanweiImageData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)configCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setItemSize:CGSizeMake(  SIZEWIDTH   / 4 ,  self.collectionContainer.height)];//设置cell的尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置其布局方向

    self.collectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.collectionContainer.frame.size.height) collectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionContainer addSubview:self.collectionView];
}

- (void)adjustFrame{
    if(IS_IPHONE_X){
        self.naviTop.constant = 44.0f;
    }
    [self.headImage.layer addCircleBoardWithRadius:SIZEHEIGHT * 0.158 / 2  boardColor:[UIColor whiteColor] boardWidth:5];    
}

#pragma mark ------------- UICollectionView -------------------
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.linkmanArr.count + 1;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    if(indexPath.row == self.linkmanArr.count){
        cell.addBtn.hidden = NO;
        cell.headImage.hidden = YES;
        cell.nameLabel.text = @"";
    }
    else{
        cell.addBtn.hidden = YES;
        cell.headImage.hidden = NO;
        cell.nameLabel.text = self.linkmanArr[indexPath.row][@"elderName"];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.linkmanArr[indexPath.row][@"headImgUrl"]] placeholderImage:_zhanweiImageData];
        
    }
    return cell;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.messageBth.hidden = YES;
    self.hartRateBtn.hidden = YES;
    self.locationBtn.hidden = YES;
    if (indexPath.row == self.linkmanArr.count) {
        AddAddressViewController *add = [[AddAddressViewController alloc]init];
        add.type = 1;
        [self.navigationController pushViewController:add animated:YES];
    } else {
        self.curretOlder = self.linkmanArr[indexPath.row];
    }
    
}

- (IBAction)goToMy:(UITapGestureRecognizer *)sender {
    MyViewController *My = [[MyViewController alloc]init];
    [self.navigationController pushViewController:My animated:YES];
}
- (IBAction)goToAddressBook:(UIButton *)sender {
    AddressBookViewController *address = [AddressBookViewController new];
    [self.navigationController pushViewController:address animated:YES];
}
- (IBAction)goToAlarm:(UIButton *)sender {
}
- (IBAction)goToGroup:(UIButton *)sender {
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZEWIDTH, SIZEHEIGHT)];
    grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupGrayViewTap)];
    [grayView addGestureRecognizer:tap];
    self.groupPullView = grayView;
    pullView *view = [[NSBundle mainBundle] loadNibNamed:@"pullView" owner:self options:nil].firstObject;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self.groupBtn convertRect: self.groupBtn.bounds toView:window];
    view.frame = CGRectMake(SIZEWIDTH - 153, rect.origin.y + rect.size.height + 3, 140, 45);
    [grayView addSubview:view];
    [window addSubview:grayView];
    //动画效果
    view.center = CGPointMake(SIZEWIDTH - 13 - 42, rect.origin.y + rect.size.height + 3 + 13.5);
    view.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:0.3 animations:^{
        view.center = CGPointMake(SIZEWIDTH - 83, rect.origin.y + rect.size.height + 3 + 22.5);
        view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)groupGrayViewTap{
    
    [self.groupPullView removeFromSuperview];
    TendViewController *tend = [TendViewController new];
    [self.navigationController pushViewController:tend animated:YES];
}

- (IBAction)goToLook:(UITapGestureRecognizer *)sender {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/device/ys/getAccessToken.do" params:nil withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            NSString *accessToken = showdata[@"accessToken"];
            [EZOPENSDK setAccessToken:accessToken];
            LookViewController *lookVC = [LookViewController new];
            lookVC.accessToken = showdata[@"accessToken"];
            [self.navigationController pushViewController:lookVC animated:YES];
        }
    }];
    
}
- (IBAction)goToCall:(UITapGestureRecognizer *)sender {
    CallPushView *view = [[NSBundle mainBundle] loadNibNamed:@"CallPushView" owner:self options:nil].firstObject;
    view.headImage.image = self.headImage.image;
    view.nameLabel.text = self.curretOlder[@"elderName"];
    view.phoneLabel.text = self.curretOlder[@"mobile"];
    if ([self.curretOlder[@"mobile"] isEqualToString:@""]) {
        view.phoneImage.image = IMAGE_NAMED(@"孝相伴-27");
        view.phoneBtn.enabled = NO;
    }
    view.watchLabel.text = self.curretOlder[@"devPhone"];
    if ([self.curretOlder[@"devPhone"] isEqualToString:@""]) {
        view.watchImage.image = IMAGE_NAMED(@"孝相伴-28");
        view.watchBtn.enabled = NO;
    }
    view.block = ^(NSInteger type) {
        NSString *tel = @"";
        if (type == 2) {
            tel = self.curretOlder[@"mobile"];
        }
        else{
            tel = self.curretOlder[@"devPhone"];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",tel]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",tel]]];
        }
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
}
- (IBAction)goToHelp:(UITapGestureRecognizer *)sender {
    HelpViewController *helpVC = [HelpViewController new];
    [self.navigationController pushViewController:helpVC animated:YES];
}
- (IBAction)goToLocation:(UITapGestureRecognizer *)sender {
    if (!([KRUserInfo sharedKRUserInfo].deviceId.length > 0)) {
        
        NoWatchViewController *nows = [[NoWatchViewController alloc]init];
        [self.navigationController pushViewController:nows animated:YES];
        [MBProgressHUD showError:@"请先绑定设备" toView:nows.view];
    } else {
        LocationViewController *location = [LocationViewController new];
        [self.navigationController pushViewController:location animated:YES];
        
    }
}
- (IBAction)goToAskHelp:(UITapGestureRecognizer *)sender {
    AskHelpViewController *AskVC = [[AskHelpViewController alloc]init];
    [self.navigationController pushViewController:AskVC animated:YES];
}
- (IBAction)goToRobot:(UITapGestureRecognizer *)sender {
    RobotViewController *robot = [RobotViewController new];
    [self.navigationController pushViewController:robot animated:YES];
}
- (IBAction)headTap:(UITapGestureRecognizer *)sender {
    self.messageBth.hidden = !self.messageBth.hidden;
    self.hartRateBtn.hidden = !self.hartRateBtn.hidden;
    self.locationBtn.hidden = !self.locationBtn.hidden;
    if (!self.hartRateBtn.hidden) {
        self.hartRateBtn.hidden = [self.curretOlder[@"devPhone"] isEqualToString:@""] ? YES :NO;
    }
    if (!self.locationBtn.hidden) {
        self.locationBtn.hidden = [self.curretOlder[@"devPhone"] isEqualToString:@""] ? YES :NO;
    }
}
- (IBAction)closeAlarm:(UIButton *)sender {
    self.alarmView.hidden = YES;
}
- (IBAction)rateAction:(UIButton *)sender {
}
- (IBAction)sendMessage:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"发送问候语给%@",self.curretOlder[@"elderName"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"雄鸡报晓，精彩一天登场" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openMessage:@"雄鸡报晓，精彩一天登场"];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"三伏高温易疲惫，午间偷空小个睡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openMessage:@"三伏高温易疲惫，午间偷空小个睡"];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"健康像棵树，多晒晒阳光" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openMessage:@"健康像棵树，多晒晒阳光"];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)openMessage:(NSString *)content{
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    // 设置短信内容
    vc.body = content;
    // 设置收件人列表
    vc.recipients = @[self.curretOlder[@"mobile"]];  // 号码数组
    // 设置代理
    vc.messageComposeDelegate = self;
    // 显示控制器
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    if(result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if(result == MessageComposeResultSent) {
        NSLog(@"已经发出");
        [self showHUDWithText:@"发送成功"];
    } else {
        NSLog(@"发送失败");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)goLocation:(UIButton *)sender {
    if (!([KRUserInfo sharedKRUserInfo].deviceId.length > 0)) {
       
        NoWatchViewController *no = [[NoWatchViewController alloc]init];
        [self.navigationController pushViewController:no animated:YES];
        [MBProgressHUD showError:@"请先绑定设备" toView:no.view];
    } else {
        LocationViewController *location = [LocationViewController new];
        [self.navigationController pushViewController:location animated:YES];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self showNaviBar];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
