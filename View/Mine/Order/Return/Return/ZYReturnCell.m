//
//  ZYReturnCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnCell.h"
#import "GetMerchantAddressList.h"

@interface ZYReturnCell()

@property (nonatomic , strong) UIImageView *line;
@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *addressLab;
@property (nonatomic , strong) UILabel *distanceLab;

@end

@implementation ZYReturnCell

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HexRGB(0xF7FAF8);
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(6 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(28 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(43 * UI_H_SCALE);
            make.size.mas_equalTo(self.iconIV.image.size);
        }];
        
        [self.contentView addSubview:self.addressLab];
        [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).mas_offset(5);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(42 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.distanceLab];
        [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-26.5 * UI_H_SCALE);
            make.left.equalTo(self.addressLab);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_GetMerchantAddressList *)model{
    self.nameLab.text = [NSString stringWithFormat:@"%@   %@",model.contact,model.telephone];
    self.addressLab.text = model.completeAddress;
    
    if(model.distance){
        self.distanceLab.hidden = NO;
        self.distanceLab.text = [NSString stringWithFormat:@"距离  %@",model.distance];
    }else{
        self.distanceLab.hidden = YES;
    }
}

#pragma mark - getter
- (UIImageView *)line{
    if(!_line){
        _line = [UIImageView new];
        _line.image = [UIImage imageNamed:@"zy_order_return_cell_line"];
    }
    return _line;
}

- (UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.textColor = WORD_COLOR_BLACK;
        _nameLab.font = MEDIUM_FONT(15);
    }
    return _nameLab;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"zy_order_return_cell_icon"];
    }
    return _iconIV;
}

- (UILabel *)addressLab{
    if(!_addressLab){
        _addressLab = [UILabel new];
        _addressLab.textColor = WORD_COLOR_GRAY;
        _addressLab.font = FONT(15);
        _addressLab.numberOfLines = 0;
    }
    return _addressLab;
}

- (UILabel *)distanceLab{
    if(!_distanceLab){
        _distanceLab = [UILabel new];
        _distanceLab.textColor = HexRGB(0xb3b3b3);
        _distanceLab.font = FONT(12);
    }
    return _distanceLab;
}

@end
