//
//  ZYItemDetailSkuMenuServiceCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailSkuMenuServiceCell.h"

@interface ZYItemDetailSkuMenuServiceCell ()

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *serviceLab;
@property (nonatomic , strong) UILabel *priceLab;
@property (nonatomic , strong) UIImageView *selectionIV;

@property (nonatomic , strong) _m_ItemDetail_Service *model;

@end

@implementation ZYItemDetailSkuMenuServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separator.hidden = YES;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(34 * UI_H_SCALE);
            make.top.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.agreementBtn];
        [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self.titleLab.mas_right).mas_offset(-3);
        }];
        
        [self.contentView addSubview:self.selectionIV];
        [self.selectionIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.titleLab);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.titleLab);
        }];
        
        [self.contentView addSubview:self.serviceLab];
        [self.serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab);
            make.top.equalTo(self.titleLab.mas_bottom).mas_offset(3);
            make.right.equalTo(self.contentView).mas_offset(-100 * UI_H_SCALE);
        }];
    }
    return self;
}

+ (CGFloat)heightForCellWithModel:(_m_ItemDetail_Service *)model{
    CGFloat serviceHeight = [model.remarks boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 134 * UI_H_SCALE, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:FONT(12)}
                                       context:nil].size.height;
    NSString *name = model.name;
    if(model.isRequired){
        name = [name stringByAppendingString:@"(必选)"];
    }
    CGFloat titleHeight = [name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:FONT(14)}
                                                     context:nil].size.height;
    return serviceHeight + titleHeight + 3 + 14 * UI_H_SCALE;
}

- (void)showCellWithModel:(_m_ItemDetail_Service *)model{
    _model = model;
    NSString *name = model.name;
    if(model.isRequired){
        name = [name stringByAppendingString:@"(必选)"];
        model.isSelected = YES;
        self.isSelected = YES;
    }else{
        if(model.isSelected){
            self.isSelected = YES;
        }else{
            self.isSelected = NO;
        }
    }
    if(model.isNeedAgreement){
        self.agreementBtn.hidden = NO;
    }else{
        self.agreementBtn.hidden = YES;
    }
    self.titleLab.text = name;
    self.serviceLab.text = model.remarks;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",model.price];
}

#pragma mark - setter
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if(isSelected){
        self.selectionIV.image = [UIImage imageNamed:@"zy_cb_selected"];
        _model.isSelected = YES;
    }else{
        self.selectionIV.image = [UIImage imageNamed:@"zy_cb_normal"];
        _model.isSelected = NO;
    }
}

#pragma mark - getter
- (UIImageView *)selectionIV{
    if(!_selectionIV){
        _selectionIV = [UIImageView new];
    }
    return _selectionIV;
}
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = HexRGB(0x7A7C80);
        _titleLab.font = FONT(14);
    }
    return _titleLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_BLACK;
        _priceLab.font = FONT(14);
    }
    return _priceLab;
}

- (UILabel *)serviceLab{
    if(!_serviceLab){
        _serviceLab = [UILabel new];
        _serviceLab.textColor = HexRGB(0xABADB3);
        _serviceLab.font = FONT(12);
        _serviceLab.numberOfLines = 0;
        _serviceLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _serviceLab;
}

- (ZYElasticButton *)agreementBtn{
    if(!_agreementBtn){
        _agreementBtn = [ZYElasticButton new];
        _agreementBtn.backgroundColor = [UIColor clearColor];
        [_agreementBtn setImage:[UIImage imageNamed:@"zy_item_detail_service_agreement"] forState:UIControlStateNormal];
        [_agreementBtn setImage:[UIImage imageNamed:@"zy_item_detail_service_agreement"] forState:UIControlStateHighlighted];
    }
    return _agreementBtn;
}

@end
