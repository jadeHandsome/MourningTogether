//
//  ZFToolView.m
//  ZFPlayer
//
//  Created by 任子丰 on 17/6/28.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "ZFToolView.h"
#import "ZFPlayer.h"
#define ToolViewWidth 180
static const CGFloat ZFPlayerAnimationTimeInterval = 0.5f;

@interface ZFToolViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZFResolution *resoulution;

@property (nonatomic, strong) ZFPlayerItem *playerItem;
@end

@implementation ZFToolViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 0.5);
}

- (void)setResoulution:(ZFResolution *)resoulution {
    _resoulution = resoulution;
    self.lineView.hidden = NO;
    self.textLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.textLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds) - 20, 30);
    self.textLabel.text = resoulution.title;
    if (resoulution.selected) {
        self.textLabel.textColor = [UIColor redColor];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setPlayerItem:(ZFPlayerItem *)playerItem {
    _playerItem = playerItem;
    self.lineView.hidden = YES;
    self.textLabel.frame = CGRectMake(0, 0, 30, 30);

    self.textLabel.text = playerItem.videoId;
    if (playerItem.selected) {
        self.textLabel.textColor = [UIColor redColor];
        self.textLabel.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:15.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.cornerRadius = 15;
        _textLabel.layer.masksToBounds = YES;
        _textLabel.layer.borderWidth = 0.5;
    }
    return _textLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

@end

static NSString *const cellIdentifier = @"ZFToolViewCell";

@interface ZFToolView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIToolbar *toolbar;
///
@property (nonatomic, assign) ZFToolViewType type;
@end

@implementation ZFToolView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.toolbar];
        [self addSubview:self.typeLabel];
        [self addSubview:self.collectionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolbar.frame = self.bounds;
    self.typeLabel.frame = CGRectMake(20, 20, CGRectGetWidth(self.bounds) - 40, 30);
    self.collectionView.frame = CGRectMake(0, self.typeLabel.bottom + 10, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.typeLabel.bottom - 10);
}

- (void)showToolViewWithType:(ZFToolViewType)type {
    self.type = type;
    if (type == ZFToolViewTypeResolution) {
        self.typeLabel.text = @"分辨率";
    } else if (type == ZFToolViewTypeVideos) {
        self.typeLabel.text = @"选集";
    }
    ZFPlayer_Shared.toolViewShow = YES;
    [UIView animateWithDuration:ZFPlayerAnimationTimeInterval animations:^{
        self.left = ZFPlayer_ScreenWidth - ToolViewWidth;
    }];
    [self.collectionView reloadData];
}

- (void)hiddenToolView {
    ZFPlayer_Shared.toolViewShow = NO;
    self.left = ZFPlayer_ScreenWidth;
}

- (void)tapped:(id)sender {}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, 5, 40, 5);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZFToolViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _collectionView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _typeLabel;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
    }
    return _toolbar;
}

- (void)setResolutions:(NSArray<ZFResolution *> *)resolutions{
    _resolutions = resolutions;
    [self.collectionView reloadData];
}

- (void)setPlayerItems:(NSArray<ZFPlayerItem *> *)playerItems{
    _playerItems = playerItems;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == ZFToolViewTypeResolution) {
        return self.resolutions.count;
    }
    return self.playerItems.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFToolViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.type == ZFToolViewTypeResolution) {
        ZFResolution *resolution = self.resolutions[indexPath.row];
        cell.resoulution = resolution;
    } else {
        ZFPlayerItem *playerItem = self.playerItems[indexPath.row];
        cell.playerItem = playerItem;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == ZFToolViewTypeResolution) {
        for (ZFResolution *resolution in self.resolutions) {
            resolution.selected = NO;
        }
        ZFResolution *resolution = self.resolutions[indexPath.row];
        resolution.selected = YES;
        if ([self.delegate respondsToSelector:@selector(zf_changeResolution:)]) {
            [self.delegate zf_changeResolution:resolution];
        }
    } else if (self.type == ZFToolViewTypeVideos) {
        for (ZFPlayerItem *playerItem in self.playerItems) {
            playerItem.selected = NO;
        }
        ZFPlayerItem *playerItem = self.playerItems[indexPath.row];
        playerItem.selected = YES;
        if ([self.delegate respondsToSelector:@selector(zf_changeVideo:)]) {
            [self.delegate zf_changeVideo:playerItem];
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.type == ZFToolViewTypeResolution) {
        return 30;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == ZFToolViewTypeResolution) {
        return CGSizeMake(ToolViewWidth, 40);
    }
    return CGSizeMake(40, 40);
}

@end
