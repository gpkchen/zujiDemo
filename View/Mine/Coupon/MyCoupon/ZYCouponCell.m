//
//  ZYCouponCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCouponCell.h"

@interface ZYCouponCell ()

@property (nonatomic , strong) UIView *upBack;
@property (nonatomic , strong) UIView *back;
@property (nonatomic , strong) UIView *amountBack;
@property (nonatomic , strong) UILabel *amountLab;
@property (nonatomic , strong) UILabel *ruleLab;
@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UILabel *categoryLab;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UIImageView *lineIV;
@property (nonatomic , strong) UIView *rangeBack;
@property (nonatomic , strong) UILabel *rangeLab;
@property (nonatomic , strong) UIImageView *selectionIV;
@property (nonatomic , strong) UIImageView *receivedIV;

@end

@implementation ZYCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
        
        [self.contentView addSubview:self.back];
        [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.back addSubview:self.upBack];
        [self.upBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.back);
            make.height.mas_equalTo(105 * UI_H_SCALE);
        }];
        
        [self.upBack addSubview:self.amountBack];
        [self.amountBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.upBack);
            make.width.mas_equalTo(104 * UI_H_SCALE);
        }];
        
        [self.amountBack addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.amountBack);
            make.centerY.equalTo(self.amountBack.mas_top).mas_offset(43 * UI_H_SCALE);
        }];
        
        [self.amountBack addSubview:self.ruleLab];
        [self.ruleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.amountBack);
            make.top.equalTo(self.amountBack).mas_offset(64 * UI_H_SCALE);
        }];
        
        [self.upBack addSubview:self.useBtn];
        [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.upBack).mas_offset(30 * UI_H_SCALE);
            make.right.equalTo(self.upBack).mas_offset(-15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(70 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self.upBack addSubview:self.selectionIV];
        [self.selectionIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.upBack).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.upBack);
        }];
        
        [self.upBack addSubview:self.receivedIV];
        [self.receivedIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.upBack);
            make.bottom.equalTo(self.upBack).mas_offset(-3);
        }];
        
        [self.upBack addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountBack.mas_right).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.amountBack.mas_top).mas_offset(30 * UI_H_SCALE);
            make.right.equalTo(self.useBtn.mas_left).mas_offset(-5 * UI_H_SCALE);
        }];
        
        [self.upBack addSubview:self.categoryLab];
        [self.categoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountBack.mas_right).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.amountBack.mas_top).mas_offset(55 * UI_H_SCALE);
            make.right.equalTo(self.useBtn.mas_left).mas_offset(-5 * UI_H_SCALE);
        }];
        
        [self.upBack addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountBack.mas_right).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.amountBack.mas_top).mas_offset(78.5 * UI_H_SCALE);
            make.right.equalTo(self.upBack).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.back addSubview:self.lineIV];
        [self.lineIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.upBack);
            make.centerY.equalTo(self.upBack.mas_bottom).mas_offset(-1);
        }];
        
        [self.back addSubview:self.rangeBack];
        [self.rangeBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.upBack);
            make.top.equalTo(self.upBack.mas_bottom);
            make.bottom.equalTo(self.back);
        }];
        
        [self.rangeBack addSubview:self.openBtn];
        [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rangeBack);
            make.centerY.equalTo(self.rangeBack);
            make.size.mas_equalTo(self.openBtn.size);
        }];
        
        [self.rangeBack addSubview:self.rangeLab];
    }
    return self;
}

- (void)showCellWithModel:(_m_ListUserCoupon *)model{
    [self setupValue:model];
    
    self.useBtn.enabled = YES;
    [self.useBtn setTitle:@"去使用" forState:UIControlStateNormal];
    
    self.amountBack.backgroundColor = HexRGB(0xFFF9F3);
    self.amountLab.textColor = WORD_COLOR_ORANGE;
    self.ruleLab.textColor = WORD_COLOR_BLACK;
    self.nameLab.textColor = WORD_COLOR_BLACK;
    self.categoryLab.textColor = WORD_COLOR_BLACK;
    self.timeLab.textColor = WORD_COLOR_GRAY_9B;
    self.useBtn.hidden = NO;
    self.selectionIV.hidden = YES;
    self.receivedIV.hidden = YES;
}

- (void)showHistoryCellWithModel:(_m_ListUserCoupon *)model{
    [self setupValue:model];
    
    self.amountBack.backgroundColor = UIColor.whiteColor;
    self.amountLab.textColor = WORD_COLOR_GRAY_9B;
    self.ruleLab.textColor = WORD_COLOR_GRAY_9B;
    self.nameLab.textColor = WORD_COLOR_GRAY_9B;
    self.categoryLab.textColor = WORD_COLOR_GRAY_9B;
    self.timeLab.textColor = WORD_COLOR_GRAY_9B;
    self.useBtn.enabled = NO;
    self.selectionIV.hidden = YES;
    self.receivedIV.hidden = YES;
    
    if(1 == model.invitedId){
        self.useBtn.hidden = NO;
        [self.useBtn setTitle:@"已过期" forState:UIControlStateDisabled];
    }else if(2 == model.invitedId){
        self.useBtn.hidden = NO;
        [self.useBtn setTitle:@"已使用" forState:UIControlStateDisabled];
    }else{
        self.useBtn.hidden = YES;
    }
}

- (void)showChooseCellWithModel:(_m_ListUserCoupon *)model{
    [self setupValue:model];
    
    self.amountBack.backgroundColor = HexRGB(0xFFF9F3);
    self.amountLab.textColor = WORD_COLOR_ORANGE;
    self.ruleLab.textColor = WORD_COLOR_BLACK;
    self.nameLab.textColor = WORD_COLOR_BLACK;
    self.categoryLab.textColor = WORD_COLOR_BLACK;
    self.timeLab.textColor = WORD_COLOR_GRAY_9B;
    self.useBtn.hidden = YES;
    self.selectionIV.hidden = NO;
    self.receivedIV.hidden = YES;
}

- (void)showReceiveCellWithModel:(_m_ListUserCoupon *)model{
    [self setupValue:model];
    if(model.receiveFlag){
        self.receivedIV.hidden = NO;
    }else{
        self.receivedIV.hidden = YES;
    }
    if(model.couponGrantId){
        //发放任务
        if(model.receiveFinishedFlag){
            self.useBtn.enabled = NO;
            [self.useBtn setTitle:@"已领完" forState:UIControlStateDisabled];
        }else{
            self.useBtn.enabled = YES;
            [self.useBtn setTitle:@"领取" forState:UIControlStateNormal];
        }
    }else{
        //领取的优惠券
        if(model.useFlag){
            self.useBtn.hidden = NO;
            self.useBtn.enabled = YES;
            [self.useBtn setTitle:@"去使用" forState:UIControlStateNormal];
        }else{
            
        }
    }
    
    self.amountBack.backgroundColor = HexRGB(0xFFF9F3);
    self.amountLab.textColor = WORD_COLOR_ORANGE;
    self.ruleLab.textColor = WORD_COLOR_BLACK;
    self.nameLab.textColor = WORD_COLOR_BLACK;
    self.categoryLab.textColor = WORD_COLOR_BLACK;
    self.timeLab.textColor = WORD_COLOR_GRAY_9B;
    self.useBtn.hidden = NO;
    self.selectionIV.hidden = YES;
}

- (void)setupValue:(_m_ListUserCoupon *)model{
    if(model.discount){
        NSMutableAttributedString *amount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f折",model.discount]];
        [amount addAttribute:NSFontAttributeName value:BOLD_FONT(18) range:NSMakeRange(amount.length-1, 1)];
        self.amountLab.attributedText = amount;
    }else{
        NSMutableAttributedString *amount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.0f",model.amount]];
        [amount addAttribute:NSFontAttributeName value:BOLD_FONT(18) range:NSMakeRange(0, 1)];
        self.amountLab.attributedText = amount;
    }
    self.ruleLab.text = model.rule;
    self.nameLab.text = model.type;
    self.categoryLab.text = model.useScene;
    if(model.effectiveTime){
        self.timeLab.text = [NSString stringWithFormat:@"有效期：%@",model.effectiveTime];
    }else{
        self.timeLab.text = @"";
    }
    
    self.rangeLab.text = model.useRange;
    if(model.openable){
        self.openBtn.hidden = NO;
        [self.rangeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rangeBack).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.openBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
            make.top.equalTo(self.rangeBack).mas_offset(8 * UI_H_SCALE);
        }];
    }else{
        self.openBtn.hidden = YES;
        [self.rangeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rangeBack).mas_offset(20 * UI_H_SCALE);
            make.top.equalTo(self.rangeBack).mas_offset(8 * UI_H_SCALE);
        }];
    }
    if(model.isOpen){
        self.rangeLab.numberOfLines = 0;
        self.openBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        self.rangeLab.numberOfLines = 1;
        self.openBtn.transform = CGAffineTransformMakeRotation(0);
    }
}

#pragma mark - setter
- (void)setChoosed:(BOOL)choosed{
    _choosed = choosed;
    if(choosed){
        self.selectionIV.image = [UIImage imageNamed:@"zy_coupon_selection_selected"];
    }else{
        self.selectionIV.image = [UIImage imageNamed:@"zy_coupon_selection_normal"];
    }
}

#pragma mark - getter
- (UIView *)upBack{
    if(!_upBack){
        _upBack = [UIView new];
        _upBack.backgroundColor = UIColor.whiteColor;
        _upBack.clipsToBounds = YES;
    }
    return _upBack;
}

- (UIView *)back{
    if(!_back){
        _back = [UIView new];
        _back.backgroundColor = UIColor.whiteColor;
        _back.cornerRadius = 2;
        _back.borderWidth = 0.5;
        _back.borderColor = HexRGB(0xe0e0e0);
        _back.clipsToBounds = YES;
    }
    return _back;
}

- (UIView *)amountBack{
    if(!_amountBack){
        _amountBack = [UIView new];
        _amountBack.cornerRadius = 2;
        _amountBack.borderWidth = 0.5;
        _amountBack.borderColor = HexRGB(0xe0e0e0);
        _amountBack.clipsToBounds = YES;
    }
    return _amountBack;
}

- (UILabel *)amountLab{
    if(!_amountLab){
        _amountLab = [UILabel new];
        _amountLab.font = BOLD_FONT(35);
    }
    return _amountLab;
}

- (UILabel *)ruleLab{
    if(!_ruleLab){
        _ruleLab = [UILabel new];
        _ruleLab.font = FONT(12);
        _ruleLab.textAlignment = NSTextAlignmentCenter;
        _ruleLab.numberOfLines = 0;
    }
    return _ruleLab;
}

- (ZYElasticButton *)useBtn{
    if(!_useBtn){
        _useBtn = [ZYElasticButton new];
        _useBtn.font = FONT(15);
        _useBtn.cornerRadius = 2;
        _useBtn.clipsToBounds = YES;
        [_useBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_useBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_useBtn setBackgroundColor:HexRGB(0xf5f7f7) forState:UIControlStateDisabled];
        [_useBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_useBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        [_useBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateDisabled];
        [_useBtn setTitle:@"去使用" forState:UIControlStateNormal];
    }
    return _useBtn;
}

- (UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.font = SEMIBOLD_FONT(18);
    }
    return _nameLab;
}

- (UILabel *)categoryLab{
    if(!_categoryLab){
        _categoryLab = [UILabel new];
        _categoryLab.font = FONT(15);
    }
    return _categoryLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.font = FONT(12);
    }
    return _timeLab;
}

- (UIImageView *)lineIV{
    if(!_lineIV){
        _lineIV = [UIImageView new];
        _lineIV.image = [UIImage imageNamed:@"zy_coupon_cell_line"];
        _lineIV.height = _lineIV.image.size.height;
        _lineIV.contentMode = UIViewContentModeScaleAspectFill;
        _lineIV.clipsToBounds = YES;
    }
    return _lineIV;
}

- (UIView *)rangeBack{
    if(!_rangeBack){
        _rangeBack = [UIView new];
        _rangeBack.backgroundColor = HexRGB(0xF5F7F7);
    }
    return _rangeBack;
}

- (UILabel *)rangeLab{
    if(!_rangeLab){
        _rangeLab = [UILabel new];
        _rangeLab.textColor = WORD_COLOR_GRAY_9B;
        _rangeLab.numberOfLines = 0;
        _rangeLab.font = FONT(12);
    }
    return _rangeLab;
}

- (ZYElasticButton *)openBtn{
    if(!_openBtn){
        _openBtn = [ZYElasticButton new];
        _openBtn.backgroundColor = self.rangeBack.backgroundColor;
        UIImage *img = [UIImage imageNamed:@"zy_arrow_down"];
        [_openBtn setImage:img forState:UIControlStateNormal];
        [_openBtn setImage:img forState:UIControlStateHighlighted];
        _openBtn.size = CGSizeMake(img.size.width + 16 * UI_H_SCALE, img.size.width + 16 * UI_H_SCALE);
    }
    return _openBtn;
}

- (UIImageView *)selectionIV{
    if(!_selectionIV){
        _selectionIV = [UIImageView new];
        _selectionIV.hidden = YES;
        _selectionIV.image = [UIImage imageNamed:@"zy_coupon_selection_normal"];
    }
    return _selectionIV;
}

- (UIImageView *)receivedIV{
    if(!_receivedIV){
        _receivedIV = [UIImageView new];
        _receivedIV.hidden = YES;
        _receivedIV.image = [UIImage imageNamed:@"zy_coupon_received"];
    }
    return _receivedIV;
}

@end

