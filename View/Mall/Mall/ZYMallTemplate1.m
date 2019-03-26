//
//  ZYMallTemplate1.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/19.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTemplate1.h"

static NSString *kCellIdentifier = @"ZYMallTemplate1CollectionCell";

@interface ZYMallTemplate1Cell()

@property (nonatomic , strong) UIImageView *iv;

@end

@implementation ZYMallTemplate1Cell

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.cornerRadius = 8;
        self.clipsToBounds = NO;
        self.layer.shadowColor = HexRGB(0x000000).CGColor;
        self.layer.shadowOpacity = 0.25;
        self.layer.shadowRadius = 4;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        
        _iv = [UIImageView new];
        _iv.layer.cornerRadius = 8;
        _iv.layer.masksToBounds = YES;
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iv];
        [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

@end




@interface ZYMallTemplate1()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UICollectionView *collectionView;

@end

@implementation ZYMallTemplate1

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 *UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(22 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(self.titleLab);
            make.size.mas_equalTo(CGSizeMake(4 * UI_H_SCALE, 24 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).mas_offset(65 * UI_H_SCALE);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.configureItemVOList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYMallTemplate1Cell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSString *url = self.model.configureItemVOList[indexPath.row][@"image"];
    [cell.iv loadImage:[url imageStyleUrl:CGSizeMake(380 * UI_H_SCALE, 540 * UI_H_SCALE)]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15 * UI_H_SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(190 * UI_H_SCALE, 270 * UI_H_SCALE);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15 * UI_H_SCALE, 0, 15 * UI_H_SCALE);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [ZYStatisticsService event:@"mall_choise" label:self.model.configureItemVOList[indexPath.row][@"title"]];
    !self.action ? : self.action(self.model.configureItemVOList[indexPath.row][@"url"]);
}

#pragma mark - override
- (void)showCellWithModel:(_m_AppModuleList *)model{
    [super showCellWithModel:model];
    [self.collectionView reloadData];
    self.titleLab.text = model.name;
}

#pragma mark - getter
- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = MAIN_COLOR_GREEN;
    }
    return _line;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = MEDIUM_FONT(20);
    }
    return _titleLab;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = NO;
        [_collectionView registerClass:[ZYMallTemplate1Cell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
    }
    return _collectionView;
}

@end
