//
//  ZYMallTemplate4.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/19.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTemplate4.h"


static NSString *kCellIdentifier = @"ZYMallTemplate4CollectionCell";

@interface ZYMallTemplate4Cell()

@property (nonatomic , strong) UIImageView *iv;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *priceLab;

@end

@implementation ZYMallTemplate4Cell

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(120 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-50 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-27.5 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)iv{
    if(!_iv){
        _iv = [UIImageView new];
        _iv.layer.masksToBounds = YES;
        _iv.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iv;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = MEDIUM_FONT(14);
    }
    return _titleLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_ORANGE;
        _priceLab.font = MEDIUM_FONT(18);
    }
    return _priceLab;
}

@end



@interface ZYMallTemplate4 ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYElasticButton *moreBtn;
@property (nonatomic , strong) UIImageView *arrowIV;
@property (nonatomic , strong) UIImageView *bigIV;
@property (nonatomic , strong) ZYCollectionView *collectionView;

@end

@implementation ZYMallTemplate4

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 *UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(30 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(self.titleLab);
            make.size.mas_equalTo(CGSizeMake(4 * UI_H_SCALE, 24 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.arrowIV];
        [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.right.equalTo(self.contentView).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowIV.mas_left).mas_offset(-3);
            make.centerY.equalTo(self.titleLab);
            make.width.mas_equalTo(self.moreBtn.width);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.bigIV];
        [self.bigIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(60 * UI_H_SCALE);
            make.height.mas_equalTo(120 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).mas_offset(200 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.configureItemVOList.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYMallTemplate4Cell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.model.configureItemVOList[indexPath.row + 1];
    NSString *url = dic[@"image"];
    [cell.iv loadImage:[url imageStyleUrl:CGSizeMake(240 * UI_H_SCALE, 240 * UI_H_SCALE)]];
    cell.titleLab.text = dic[@"title"];
    double price = [dic[@"price"] doubleValue];
    NSString *unit = dic[@"unit"];
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f/%@",price,unit];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAtt addAttribute:NSFontAttributeName value:MEDIUM_FONT(12) range:NSMakeRange(0, 1)];
    [priceAtt addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(priceStr.length - unit.length - 1, unit.length + 1)];
    cell.priceLab.attributedText = priceAtt;
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
    return 10 * UI_H_SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(120 * UI_H_SCALE, 187 * UI_H_SCALE);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15 * UI_H_SCALE, 0, 15 * UI_H_SCALE);
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.model.url){
        return;
    }
    if(scrollView.contentOffset.x > scrollView.contentSize.width - SCREEN_WIDTH){
        CGFloat centerY = ZYMallTemplate4Height - 93.5 * UI_H_SCALE;
        CGFloat offset = (scrollView.contentOffset.x - scrollView.contentSize.width + SCREEN_WIDTH);
        if(scrollView.contentSize.width < SCREEN_WIDTH){
            offset = scrollView.contentOffset.x;
        }
        CGFloat rate = offset / ZYMallTemplateMoreMaxOffset;
        if(!self.moreShape.superlayer){
            [self.contentView.layer addSublayer:self.moreShape];
        }
        if(!self.moreLab.superview){
            [self.contentView addSubview:self.moreLab];
            self.moreLab.frame = CGRectMake(SCREEN_WIDTH,
                                            centerY - self.moreLab.height / 2.0,
                                            self.moreLab.width,
                                            self.moreLab.height);
        }
        CGPoint beginPoint = CGPointMake(SCREEN_WIDTH, ZYMallTemplate4Height - 187 * UI_H_SCALE);
        CGPoint endPoint = CGPointMake(SCREEN_WIDTH, ZYMallTemplate4Height);
        CGPoint controlPoint = CGPointMake(SCREEN_WIDTH - offset * 2, centerY);
        [self showMorePath:beginPoint endPoint:endPoint controlPoint:controlPoint];
        self.moreLab.right = SCREEN_WIDTH - 15 * UI_H_SCALE + (1 - rate) * (15 * UI_H_SCALE + self.moreLab.width);
    }else{
        if(self.moreShape.superlayer){
            [self.moreShape removeFromSuperlayer];
        }
        if(self.moreLab.superview){
            [self.moreLab removeFromSuperview];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offset = (scrollView.contentOffset.x - scrollView.contentSize.width + SCREEN_WIDTH);
    if(offset > ZYMallTemplateMoreMaxOffset){
        if(self.model.url){
            !self.action ? : self.action(self.model.url);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    !self.action ? : self.action(self.model.configureItemVOList[indexPath.row + 1][@"url"]);
}

#pragma mark - override
- (void)showCellWithModel:(_m_AppModuleList *)model{
    [super showCellWithModel:model];
    [self.collectionView reloadData];
    self.titleLab.text = model.name;
    NSString *url = model.configureItemVOList[0][@"image"];
    url = [url imageStyleUrl:CGSizeMake((SCREEN_WIDTH - 30 * UI_H_SCALE) * 2, (SCREEN_WIDTH - 30 * UI_H_SCALE) * 0.49 * 2)];
    [self.bigIV loadImage:url];
    if(model.url){
        self.moreBtn.hidden = NO;
        self.arrowIV.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
        self.arrowIV.hidden = YES;
    }
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

- (UIImageView *)bigIV{
    if(!_bigIV){
        _bigIV = [UIImageView new];
        _bigIV.layer.masksToBounds = YES;
        _bigIV.contentMode = UIViewContentModeScaleAspectFill;
        _bigIV.userInteractionEnabled = YES;
        
        __weak __typeof__(self) weakSelf = self;
        [_bigIV tapped:^(UITapGestureRecognizer *gesture) {
            !weakSelf.action ? : weakSelf.action(weakSelf.model.configureItemVOList[0][@"url"]);
        } delegate:nil];
    }
    return _bigIV;
}

- (ZYElasticButton *)moreBtn{
    if(!_moreBtn){
        _moreBtn = [ZYElasticButton new];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        _moreBtn.backgroundColor = [UIColor whiteColor];
        _moreBtn.font = FONT(14);
        [_moreBtn setTitleColor:HexRGB(0x7E8082) forState:UIControlStateNormal];
        [_moreBtn setTitleColor:HexRGB(0x7E8082) forState:UIControlStateHighlighted];
        [_moreBtn sizeToFit];
        
        __weak __typeof__(self) weakSelf = self;
        [_moreBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.action ? : weakSelf.action(weakSelf.model.url);
        }];
    }
    return _moreBtn;
}

- (UIImageView *)arrowIV{
    if(!_arrowIV){
        _arrowIV = [UIImageView new];
        _arrowIV.image = [UIImage imageNamed:@"zy_mine_user_center_arrow"];
        _arrowIV.userInteractionEnabled = YES;
        
        __weak __typeof__(self) weakSelf = self;
        [_arrowIV tapped:^(UITapGestureRecognizer *gesture) {
            !weakSelf.action ? : weakSelf.action(weakSelf.model.url);
        } delegate:nil];
    }
    return _arrowIV;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[ZYCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = NO;
        [_collectionView registerClass:[ZYMallTemplate4Cell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
    }
    return _collectionView;
}

@end
