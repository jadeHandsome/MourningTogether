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
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
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
@property (nonatomic, copy) NSArray *linkmanArr;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *collectionContainer;

@end

@implementation HomeViewController

- (NSArray *)linkmanArr{
    if(_linkmanArr == nil){
        _linkmanArr = @[@"大姨",@"二姨"];
    }
    return _linkmanArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self hideNaviBar];
    [self adjustFrame];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self configCollectionView];
}

- (void)configCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setItemSize:CGSizeMake(  SIZEWIDTH   / 4 ,  self.collectionContainer.height)];//设置cell的尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置其布局方向

    self.collectionView  = [[UICollectionView alloc]initWithFrame:self.collectionContainer.bounds collectionViewLayout:flowLayout];
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
    if(indexPath.item == self.linkmanArr.count){
        cell.addBtn.hidden = NO;
        cell.headImage.hidden = YES;
    }
    else{
        cell.addBtn.hidden = YES;
        cell.headImage.hidden = NO;
        cell.nameLabel.text = self.linkmanArr[indexPath.item];
        
    }
    return cell;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (IBAction)goToMy:(UITapGestureRecognizer *)sender {
    MineViewController *mine = [[MineViewController alloc]init];
    [self.navigationController pushViewController:mine animated:YES];
}
- (IBAction)goToAddressBook:(UIButton *)sender {
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

}

- (void)groupGrayViewTap{
    [self.groupPullView removeFromSuperview];
}

- (IBAction)goToLook:(UITapGestureRecognizer *)sender {
}
- (IBAction)goToCall:(UITapGestureRecognizer *)sender {
    CallPushView *view = [[NSBundle mainBundle] loadNibNamed:@"CallPushView" owner:self options:nil].firstObject;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
}
- (IBAction)goToHelp:(UITapGestureRecognizer *)sender {
}
- (IBAction)goToLocation:(UITapGestureRecognizer *)sender {
}
- (IBAction)goToAskHelp:(UITapGestureRecognizer *)sender {
}
- (IBAction)goToRobot:(UITapGestureRecognizer *)sender {
}
- (IBAction)headTap:(UITapGestureRecognizer *)sender {
    self.hartRateBtn.hidden = !self.hartRateBtn.hidden;
    self.messageBth.hidden = !self.messageBth.hidden;
    self.locationBtn.hidden = !self.locationBtn.hidden;
}
- (IBAction)closeAlarm:(UIButton *)sender {
    self.alarmView.hidden = YES;
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
