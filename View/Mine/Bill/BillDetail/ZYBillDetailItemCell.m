//
//  ZYBillDetailItemCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillDetailItemCell.h"
#import "GetOrderBillDetail.h"

@interface ZYBillDetailItemCell ()

@property (nonatomic , strong) UIImageView *itemIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *skuLab;
@property (nonatomic , strong) UILabel *priceLab;

@end

@implementation ZYBillDetailItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.itemIV];
        [self.itemIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.bottom.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.width.mas_equalTo(ZYBillDetailItemCellHeight - 30 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(34 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.skuLab];
        [self.skuLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);;
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(57 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);;
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-37 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_GetOrderBillDetail *)model{
    NSString *url = [model.imageUrl imageStyleUrl:CGSizeMake((ZYBillDetailItemCellHeight - 30 * UI_H_SCALE) * 2, (ZYBillDetailItemCellHeight - 30 * UI_H_SCALE) * 2)];
    [self.itemIV loadImage:url];
    self.titleLab.text = model.title;
    self.skuLab.text = [NSString stringWithFormat:@"规格:%@",model.goodsSkuNames];
    self.priceLab.text = model.rentPrice;
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
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(14);
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
        _priceLab.textColor = WORD_COLOR_BLACK;
        _priceLab.font = MEDIUM_FONT(14);
    }
    return _priceLab;
}


@end
