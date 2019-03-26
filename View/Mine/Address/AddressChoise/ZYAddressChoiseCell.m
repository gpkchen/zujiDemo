//
//  ZYAddressChoiseCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddressChoiseCell.h"

@interface ZYAddressChoiseCell ()

@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UILabel *mobileLab;
@property (nonatomic , strong) UILabel *addressLab;

@end

@implementation ZYAddressChoiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(28.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.mobileLab];
        [self.mobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLab.mas_right).mas_offset(15 * UI_H_SCALE);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.nameLab);
        }];
        
        [self.contentView addSubview:self.addressLab];
        [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(66 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_AddressList *)model{
    self.nameLab.text = model.contact;
    self.mobileLab.text = model.mobile;
    NSString *address = @"";
    if(model.provinceName){
        address = [address stringByAppendingString:model.provinceName];
    }
    if(model.cityName){
        address = [address stringByAppendingString:model.cityName];
    }
    if(model.districtName){
        address = [address stringByAppendingString:model.districtName];
    }
    if(model.address){
        address = [address stringByAppendingString:model.address];
    }
    if(model.isDefault){
        NSString *addr = [NSString stringWithFormat:@"%@[默认地址]",address];
        NSMutableAttributedString *addressAtt = [[NSMutableAttributedString alloc] initWithString:addr];
        [addressAtt addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR_GREEN range:NSMakeRange(addressAtt.length - 6, 6)];
        self.addressLab.attributedText = addressAtt;
    }else{
        self.addressLab.text = address;
    }
}

#pragma mark - getter
- (UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.textColor = WORD_COLOR_BLACK;
        _nameLab.font = MEDIUM_FONT(18);
    }
    return _nameLab;
}

- (UILabel *)mobileLab{
    if(!_mobileLab){
        _mobileLab = [UILabel new];
        _mobileLab.textColor = WORD_COLOR_BLACK;
        _mobileLab.font = MEDIUM_FONT(18);
    }
    return _mobileLab;
}

- (UILabel *)addressLab{
    if(!_addressLab){
        _addressLab = [UILabel new];
        _addressLab.textColor = WORD_COLOR_BLACK;
        _addressLab.font = FONT(14);
        _addressLab.numberOfLines = 2;
        _addressLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _addressLab;
}

@end
