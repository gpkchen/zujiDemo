//
//  ZYItemCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemCell.h"

@implementation ZYItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.itemIV];
        [self.itemIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.bottom.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.width.mas_equalTo(ZYItemCellHeight - 30 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(28 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.skuLab];
        [self.skuLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);;
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(51 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);;
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-32 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)itemIV{
    if(!_itemIV){
        _itemIV = [UIImageView new];
        _itemIV.contentMode = UIViewContentModeScaleAspectFill;
        _itemIV.clipsToBounds = YES;
    }
    return _itemIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = HexRGB(0x333333);
        _titleLab.font = FONT(16);
    }
    return _titleLab;
}

- (UILabel *)skuLab{
    if(!_skuLab){
        _skuLab = [UILabel new];
        _skuLab.textColor = WORD_COLOR_GRAY;
        _skuLab.font = FONT(14);
    }
    return _skuLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_ORANGE;
        _priceLab.font = MEDIUM_FONT(14);
    }
    return _priceLab;
}

@end
