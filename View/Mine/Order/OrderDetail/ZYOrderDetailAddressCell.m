//
//  ZYOrderDetailAddressCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderDetailAddressCell.h"
#import "GetOrderDetail.h"

@interface ZYOrderDetailAddressCell ()

@property (nonatomic , strong) UILabel *wayLab;
@property (nonatomic , strong) UIImageView *bottomLine;
@property (nonatomic , strong) UILabel *receiverLab;
@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *addressLab;

@end

@implementation ZYOrderDetailAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.wayLab];
        [self.wayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(70 * UI_H_SCALE, 25 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.receiverLab];
        [self.receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(59 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-40 * UI_H_SCALE);
            make.size.mas_equalTo(self.iconIV.image.size);
        }];
        
        [self.contentView addSubview:self.addressLab];
        [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).mas_offset(8 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-47 * UI_H_SCALE);
            make.centerY.equalTo(self.iconIV);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_GetOrderDetail *)model{
    if(model.expressType == ZYExpressTypeMail){
        self.wayLab.text = @"邮寄";
        self.receiverLab.text = [NSString stringWithFormat:@"收件人：%@    %@",model.reciveContact,model.reciveMobile];
    }else{
        self.wayLab.text = @"自提";
        self.receiverLab.text = [NSString stringWithFormat:@"门店：%@    %@",model.reciveContact,model.reciveMobile];
    }
    
    self.addressLab.text = model.reciveAddress;
}

#pragma mark - getter
- (UIImageView *)bottomLine{
    if(!_bottomLine){
        _bottomLine = [UIImageView new];
        _bottomLine.image = [UIImage imageNamed:@"zy_address_bottom_line"];
    }
    return _bottomLine;
}

- (UILabel *)wayLab{
    if(!_wayLab){
        _wayLab = [UILabel new];
        _wayLab.backgroundColor = [UIColor whiteColor];
        _wayLab.textColor = MAIN_COLOR_GREEN;
        _wayLab.font = FONT(14);
        _wayLab.borderColor = MAIN_COLOR_GREEN;
        _wayLab.borderWidth = 1;
        _wayLab.textAlignment = NSTextAlignmentCenter;
        _wayLab.cornerRadius = 12.5 * UI_H_SCALE;
    }
    return _wayLab;
}

- (UILabel *)receiverLab{
    if(!_receiverLab){
        _receiverLab = [UILabel new];
        _receiverLab.textColor = WORD_COLOR_BLACK;
        _receiverLab.font = FONT(14);
    }
    return _receiverLab;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"zy_address_location_icon"];
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

@end
