//
//  VideoPlayViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/18.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "ZFPlayer.h"
#import "IQKeyboardManager.h"
#import "CommentCell.h"
@interface VideoPlayViewController ()<UIWebViewDelegate,ZFPlayerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (nonatomic, assign) NSInteger nowCount;

@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation VideoPlayViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    self.nowCount = 0;
    [self.indicator startAnimating];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData{
    NSDictionary *params = @{@"mediaId":self.mediaId,@"offset":@(self.nowCount),@"size":@(10)};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/vod/getVodCommentList.do" params:params withModel:nil complateHandle:^(id showdata, NSString *error) {
        self.indicator.hidden = YES;
        if ([showdata[@"commentList"] count] == 0) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.data addObjectsFromArray:showdata[@"commentList"]];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)setUp{
    self.topConstraint.constant = navHight;
    self.playerModel                  = [[ZFPlayerModel alloc] init];
    self.playerModel.videoURL         = [NSURL URLWithString:self.URL];
    self.playerModel.fatherView       = self.playerFatherView;
    self.playerView = [[ZFPlayerView alloc] init];
    [self.playerView playerControlView:nil playerModel:self.playerModel];
    // 设置代理
    self.playerView.delegate = self;
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
    // 打开预览图
    self.playerView.hasPreviewView = YES;
    [self.playerView autoPlayTheVideo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    LRViewBorderRadius(self.textView, 5, 1, [UIColor grayColor]);
    self.textView.delegate = self;
    self.tableView.estimatedRowHeight = 150;
    [KRBaseTool tableViewAddRefreshHeader:self.tableView withTarget:self refreshingAction:@selector(reloadData)];
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMoreData)];
}

- (void)reloadData{
    self.nowCount = 0;
    [self.data removeAllObjects];
    [self requestData];
}

- (void)getMoreData{
    self.nowCount += 10;
    [self requestData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    cell.nameLabel.text = self.data[indexPath.row][@"memberName"];
    cell.timeLabel.text = [self changeTimeStr:self.data[indexPath.row][@"commentTime"]];
    cell.contentLabel.text = self.data[indexPath.row][@"comment"];
    return cell;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *str = textView.text;
    CGSize MaxSize = CGSizeMake(SIZEWIDTH, MAXFLOAT);
    CGRect frame = [str boundingRectWithSize:MaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil];
    CGFloat tarHeight = 40;
    if (frame.size.height + 10 > 40) {
        tarHeight = frame.size.height + 10;
    }
    if (tarHeight > 60) {
        tarHeight = 60;
    }
    self.bottomHeight.constant = tarHeight + 10;
    [self.view layoutIfNeeded];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        //发送
        NSDictionary *params = @{@"mediaId":self.mediaId,@"comment":textView.text};
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"/mgr/vod/addVodComment.do" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (showdata) {
                textView.text = nil;
                self.placeholderLabel.hidden = NO;
                [self.tableView.mj_header beginRefreshing];
            }
        }];
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    CGFloat height = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animtionType = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.bottomConstraint.constant = height;
    [UIView animateWithDuration:duration delay:0 options:animtionType animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
//    CGFloat height = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animtionType = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:duration delay:0 options:animtionType animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


- (NSString *)changeTimeStr:(NSString *)str{
    NSString *year = [str substringToIndex:4];
    NSString *month = [str substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [str substringWithRange:NSMakeRange(6, 2)];
    NSString *hour = [str substringWithRange:NSMakeRange(8, 2)];
    NSString *min = [str substringWithRange:NSMakeRange(10, 2)];
    NSString *sec = [str substringWithRange:NSMakeRange(12, 2)];
    NSString *time = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,min,sec];
    return time;
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
