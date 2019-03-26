//
//  ZYOrderConfirmAddressCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderConfirmAddressCell.h"
#import "AddressList.h"
#import "MerchantAddressList.h"

@interface ZYOrderConfirmAddressCell ()

@property (nonatomic , strong) UIImageView *bottomLine;
@property (nonatomic , strong) UILabel *receiverLab;
@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *addressLab;
@property (nonatomic , strong) UILabel *indexLab;
@property (nonatomic , strong) UILabel *distanceLab;

@end

@implementation ZYOrderConfirmAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.mailBtn];
        [self.mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(26.5 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(70 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.selfLiftingBtn];
        [self.selfLiftingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mailBtn.mas_right).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(26.5 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(70 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self selectBtn:self.mailBtn];
        
        [self.contentView addSubview:self.receiverLab];
        [self.receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(59 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(76 * UI_H_SCALE);
            make.size.mas_equalTo(self.iconIV.image.size);
        }];
        
        [self.contentView addSubview:self.addressLab];
        [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).mas_offset(8 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-47 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(73 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.indexLab];
        [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressLab);
            make.bottom.equalTo(self.contentView).mas_offset(-16 * UI_H_SCALE);
            make.height.mas_equalTo(20 * UI_H_SCALE);
            make.width.mas_equalTo(36 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.distanceLab];
        [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.indexLab);
            make.left.equalTo(self.indexLab.mas_right).mas_offset(10 * UI_H_SCALE);
        }];
        
        self.arrow.hidden = NO;
        [self.arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.iconIV);
            make.size.mas_equalTo(self.arrow.image.size);
        }];
        
        [self.contentView addSubview:self.noAddressLab];
        [self.noAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).mas_offset(7 * UI_H_SCALE);
            make.centerY.equalTo(self.iconIV);
        }];
    }
    return self;
}

- (void)selectBtn:(ZYElasticButton *)btn{
    btn.selected = YES;
    btn.borderColor = BTN_COLOR_NORMAL_GREEN;
    ZYElasticButton *otherBtn = nil;
    if([btn isEqual:self.mailBtn]){
        otherBtn = self.selfLiftingBtn;
    }else{
        otherBtn = self.mailBtn;
    }
    otherBtn.selected = NO;
    otherBtn.borderColor = WORD_COLOR_GRAY;
}

- (void)showCellWithAddressModel:(_m_AddressList *)model{
    self.indexLab.hidden = YES;
    self.distanceLab.hidden = YES;
    if(!model){
        self.noAddress = YES;
        self.noAddressLab.text = @"添加收货地址";
    }else{
        self.noAddress = NO;
        self.receiverLab.text = [NSString stringWithFormat:@"收件人：%@    %@",model.contact,model.mobile];
        self.addressLab.text = model.address;
    }
}

- (void)showCellWithStoreModel:(_m_MerchantAddressList *)model{
    if(!model){
        self.noAddress = YES;
        self.noAddressLab.text = @"添加门店地址";
        self.distanceLab.hidden = YES;
        self.indexLab.hidden = YES;
    }else{
        self.noAddress = NO;
        self.receiverLab.text = [NSString stringWithFormat:@"门店：%@    %@",model.addressName,model.telephone];
        self.addressLab.text = model.completeAddress;
        
        if(model.distance){
            self.distanceLab.hidden = NO;
            self.distanceLab.text = [NSString stringWithFormat:@"距离%@",model.distance];
            
            self.indexLab.hidden = NO;
            if(0 == model.index){
                self.indexLab.text = @"最近";
                self.indexLab.textColor = HexRGB(0x14CC61);
                self.indexLab.font = FONT(12);
                self.indexLab.backgroundColor = HexRGB(0xCEF0DE);
                [self.indexLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(36 * UI_H_SCALE);
                }];
            }else{
                if(model.index + 1 < 10){
                    self.indexLab.text = [NSString stringWithFormat:@"0%d",model.index + 1];
                }else{
                    self.indexLab.text = [NSString stringWithFormat:@"%d",model.index + 1];
                }
                self.indexLab.textColor = WORD_COLOR_GRAY_9B;
                self.indexLab.font = BOLD_FONT(15);
                self.indexLab.backgroundColor = self.backgroundColor;
                [self.indexLab sizeToFit];
                [self.indexLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(self.indexLab.width);
                }];
            }
        }else{
            self.distanceLab.hidden = YES;
            self.indexLab.hidden = YES;
        }
    }
}

- (void)setNoAddress:(BOOL)noAddress{
    if(noAddress){
        self.receiverLab.hidden = YES;
        self.addressLab.hidden = YES;
        self.noAddressLab.hidden = NO;
        
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(56 * UI_H_SCALE);
            make.size.mas_equalTo(self.iconIV.image.size);
        }];
    }else{
        self.receiverLab.hidden = NO;
        self.addressLab.hidden = NO;
        self.noAddressLab.hidden = YES;
        
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(76 * UI_H_SCALE);
            make.size.mas_equalTo(self.iconIV.image.size);
        }];
    }
}

#pragma mark - getter
- (UIImageView *)bottomLine{
    if(!_bottomLine){
        _bottomLine = [UIImageView new];
        _bottomLine.image = [UIImage imageNamed:@"zy_address_bottom_line"];
    }
    return _bottomLine;
}

- (ZYElasticButton *)mailBtn{
    if(!_mailBtn){
        _mailBtn = [ZYElasticButton new];
        [_mailBtn setTitle:@"邮寄" forState:UIControlStateNormal];
        [_mailBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_mailBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateSelected];
        _mailBtn.font = FONT(14);
        _mailBtn.shouldRound = YES;
        _mailBtn.cornerRadius = 12.5 * UI_H_SCALE;
        _mailBtn.backgroundColor = [UIColor whiteColor];
        _mailBtn.borderColor = WORD_COLOR_GRAY;
        _mailBtn.borderWidth = 1;
    }
    return _mailBtn;
}

- (ZYElasticButton *)selfLiftingBtn{
    if(!_selfLiftingBtn){
        _selfLiftingBtn = [ZYElasticButton new];
        [_selfLiftingBtn setTitle:@"自提" forState:UIControlStateNormal];
        [_selfLiftingBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_selfLiftingBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateSelected];
        _selfLiftingBtn.font = FONT(14);
        _selfLiftingBtn.shouldRound = YES;
        _selfLiftingBtn.cornerRadius = 12.5 * UI_H_SCALE;
        _selfLiftingBtn.backgroundColor = [UIColor whiteColor];
        _selfLiftingBtn.borderColor = WORD_COLOR_GRAY;
        _selfLiftingBtn.borderWidth = 1;
    }
    return _selfLiftingBtn;
}

- (UILabel *)receiverLab{
    if(!_receiverLab){
        _receiverLab = [UILabel new];
        _receiverLab.textColor = WORD_COLOR_BLACK;
        _receiverLab.font = BOLD_FONT(14);
    }
    return _receiverLab;
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
        _addressLab.font = FONT(13);
        _addressLab.numberOfLines = 2;
        _addressLab.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    }
    return _addressLab;
}

- (UILabel *)noAddressLab{
    if(!_noAddressLab){
        _noAddressLab = [UILabel new];
        _noAddressLab.text = @"添加收货地址";
        _noAddressLab.font = FONT(14);
        _noAddressLab.textColor = WORD_COLOR_BLACK;
        _noAddressLab.hidden = YES;
    }
    return _noAddressLab;
}

- (UILabel *)distanceLab{
    if(!_distanceLab){
        _distanceLab = [UILabel new];
        _distanceLab.textColor = HexRGB(0xb3b3b3);
        _distanceLab.font = FONT(12);
    }
    return _distanceLab;
}

- (UILabel *)indexLab{
    if(!_indexLab){
        _indexLab = [UILabel new];
        _indexLab.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLab;
}

@end
