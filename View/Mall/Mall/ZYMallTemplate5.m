//
//  ZYMallTemplate5.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTemplate5.h"

static NSString *kCellIdentifier = @"ZYMallTemplate5CollectionCell";

@interface ZYMallTemplate5Cell()

@property (nonatomic , strong) UIImageView *iv;

@end

@implementation ZYMallTemplate5Cell

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        _iv = [UIImageView new];
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




@interface ZYMallTemplate5()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) ZYCollectionView *collectionView;

@end


@implementation ZYMallTemplate5

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
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
    ZYMallTemplate5Cell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSString *url = self.model.configureItemVOList[indexPath.row][@"image"];
    [cell.iv loadImage:[url imageStyleUrl:CGSizeMake(280 * UI_H_SCALE, 440 * UI_H_SCALE)]];
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
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(84 * UI_H_SCALE, 120 * UI_H_SCALE);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.model.configureItemVOList[indexPath.row];
    !self.action ? : self.action(dic[@"url"]);
    [ZYStatisticsService event:@"mall_navigation" label:dic[@"title"]];
    
}

#pragma mark - override
- (void)showCellWithModel:(_m_AppModuleList *)model{
    [super showCellWithModel:model];
    [self.collectionView reloadData];
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[ZYCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZYMallTemplate5Cell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
    }
    return _collectionView;
}

@end
