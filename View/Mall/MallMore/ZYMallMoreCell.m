//
//  ZYMallMoreCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallMoreCell.h"
#import "AppListItem.h"

@interface ZYMallMoreCell ()

@property (nonatomic , strong) UIImageView *iv;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *yuanLab;
@property (nonatomic , strong) UILabel *priceLab;

@end

@implementation ZYMallMoreCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.cornerRadius = 10;
        self.clipsToBounds = YES;
        
        [self.contentView addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(168 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(10 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(183 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(206.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.yuanLab];
        [self.yuanLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.priceLab.mas_left);
            make.top.equalTo(self.priceLab).mas_offset(2);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_AppListItem *)model{
    NSString *url = [model.image imageStyleUrl:CGSizeMake((SCREEN_WIDTH - 45 * UI_H_SCALE), 336 * UI_H_SCALE)];
    [self.iv loadImage:url];
    self.titleLab.text = model.subTitle;
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f/%@",model.price,model.unit]];
    [price addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(price.length - model.unit.length - 1, model.unit.length + 1)];
    self.priceLab.attributedText = price;
}

#pragma mark - getter
- (UIImageView *)iv{
    if(!_iv){
        _iv = [UIImageView new];
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        _iv.clipsToBounds = YES;
    }
    return _iv;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(14);
    }
    return _titleLab;
}

- (UILabel *)yuanLab{
    if(!_yuanLab){
        _yuanLab = [UILabel new];
        _yuanLab.textColor = WORD_COLOR_ORANGE;
        _yuanLab.font = FONT(12);
        _yuanLab.text = @"￥";
    }
    return _yuanLab;
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
