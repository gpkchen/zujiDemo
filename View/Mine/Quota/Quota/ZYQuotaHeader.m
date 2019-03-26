//
//  ZYQuotaHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYQuotaHeader.h"
#import "AuditStatus.h"

@interface ZYQuotaHeader()

@property (nonatomic , strong) UIImageView *amountBackIV;
@property (nonatomic , strong) UILabel *amountTitleLab;
@property (nonatomic , strong) UILabel *amountLab;
@property (nonatomic , strong) UILabel *totalAmountLab;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *tmpQuotaLab;

@end

@implementation ZYQuotaHeader

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.amountBackIV];
        [self.amountBackIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(212 * UI_H_SCALE);
        }];
        
        [self addSubview:self.amountTitleLab];
        [self.amountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(35 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_top).mas_offset(40 * UI_H_SCALE);
        }];
        
        [self addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(35 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_top).mas_offset(76 * UI_H_SCALE);
        }];
        
        [self addSubview:self.totalAmountLab];
        [self.totalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(35 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_top).mas_offset(146.5 * UI_H_SCALE);
        }];
        
        [self addSubview:self.tmpQuotaLab];
        [self.tmpQuotaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalAmountLab);
            make.top.equalTo(self.totalAmountLab.mas_bottom);
        }];
        
        [self addSubview:self.quotaHelpBtn];
        [self.quotaHelpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalAmountLab.mas_right);
            make.centerY.equalTo(self.totalAmountLab);
            make.size.mas_equalTo(self.quotaHelpBtn.size);
        }];
        
        [self addSubview:self.recordBtn];
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-35 * UI_H_SCALE);
            make.top.equalTo(self.amountBackIV.mas_top).mas_offset(26 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 28 * UI_H_SCALE));
        }];
        
        [self addSubview:self.instructionBtn];
        [self.instructionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recordBtn);
            make.centerY.equalTo(self.amountBackIV.mas_top).mas_offset(80 * UI_H_SCALE);
            make.size.mas_equalTo(self.instructionBtn.size);
        }];
        
        [self addSubview:self.authBtn];
        [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-35 * UI_H_SCALE);
            make.top.equalTo(self.amountBackIV.mas_top).mas_offset(136 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setAuthInfo:(_m_AuditStatus *)authInfo{
    _authInfo = authInfo;
    
    self.amountLab.text = [NSString stringWithFormat:@"%.2f",authInfo.limit];
    
    NSString *total = [NSString stringWithFormat:@"总额度(元):%.2f",authInfo.totalLimit];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:total];
    [att addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(0, 7)];
    self.totalAmountLab.attributedText = att;
    
    if(authInfo.tempLimitFlag){
        self.quotaHelpBtn.hidden = NO;
        self.tmpQuotaLab.hidden = NO;
    }else{
        self.quotaHelpBtn.hidden = YES;
        self.tmpQuotaLab.hidden = YES;
    }
    
    if(authInfo.status == ZYAuthStateImprove){
        self.authBtn.hidden = NO;
        [self.authBtn setTitle:@"提额中" forState:UIControlStateNormal];
    }else{
        self.authBtn.hidden = YES;
    }
}

#pragma mark - getter
- (UIImageView *)amountBackIV{
    if(!_amountBackIV){
        _amountBackIV = [UIImageView new];
        _amountBackIV.image = [UIImage imageNamed:@"zy_quota_amunt_back"];
    }
    return _amountBackIV;
}

- (UILabel *)amountTitleLab{
    if(!_amountTitleLab){
        _amountTitleLab = [UILabel new];
        _amountTitleLab.textColor = UIColor.whiteColor;
        _amountTitleLab.font = FONT(14);
        _amountTitleLab.text = @"可用额度(元)";
    }
    return _amountTitleLab;
}

- (UILabel *)amountLab{
    if(!_amountLab){
        _amountLab = [UILabel new];
        _amountLab.textColor = UIColor.whiteColor;
        _amountLab.font = BOLD_FONT(42);
        _amountLab.text = @"0.00";
    }
    return _amountLab;
}

- (UILabel *)totalAmountLab{
    if(!_totalAmountLab){
        _totalAmountLab = [UILabel new];
        _totalAmountLab.textColor = UIColor.whiteColor;
        _totalAmountLab.font = BOLD_FONT(18);
        _totalAmountLab.text = @"0.00";
    }
    return _totalAmountLab;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(18);
        _titleLab.text = @"提额任务";
    }
    return _titleLab;
}

- (UILabel *)tmpQuotaLab{
    if(!_tmpQuotaLab){
        _tmpQuotaLab = [UILabel new];
        _tmpQuotaLab.textColor = UIColor.whiteColor;
        _tmpQuotaLab.font = MEDIUM_FONT(12);
        _tmpQuotaLab.text = @"(含临时额度)";
    }
    return _tmpQuotaLab;
}

- (ZYElasticButton *)quotaHelpBtn{
    if(!_quotaHelpBtn){
        _quotaHelpBtn = [ZYElasticButton new];
        _quotaHelpBtn.backgroundColor = UIColor.clearColor;
        UIImage *img= [UIImage imageNamed:@"zy_mine_quota_help"];
        [_quotaHelpBtn setImage:img forState:UIControlStateNormal];
        [_quotaHelpBtn setImage:img forState:UIControlStateHighlighted];
        _quotaHelpBtn.size = CGSizeMake(img.size.width + 16, img.size.height + 16);
    }
    return _quotaHelpBtn;
}

- (ZYElasticButton *)recordBtn{
    if(!_recordBtn){
        _recordBtn = [ZYElasticButton new];
        _recordBtn.shouldRound = YES;
        _recordBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _recordBtn.font = MEDIUM_FONT(14);
        [_recordBtn setTitle:@"变更记录" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_recordBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    }
    return _recordBtn;
}

- (ZYElasticButton *)instructionBtn{
    if(!_instructionBtn){
        _instructionBtn = [ZYElasticButton new];
        _instructionBtn.backgroundColor = UIColor.clearColor;
        
        __weak __typeof__(_instructionBtn) weakBtn = _instructionBtn;
        UILabel *lab = [UILabel new];
        lab.textColor = UIColor.whiteColor;
        lab.text = @"额度说明";
        lab.font = MEDIUM_FONT(12);
        [lab sizeToFit];
        [_instructionBtn addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakBtn);
            make.centerY.equalTo(weakBtn);
        }];
        
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"zy_mine_quota_instruction_arrow"];
        [_instructionBtn addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakBtn);
            make.left.equalTo(lab.mas_right).mas_offset(4 * UI_H_SCALE);
        }];
        
        _instructionBtn.size = CGSizeMake(lab.width + 4 * UI_H_SCALE + iv.image.size.width, 28 * UI_H_SCALE);
    }
    return _instructionBtn;
}

- (ZYElasticButton *)authBtn{
    if(!_authBtn){
        _authBtn = [ZYElasticButton new];
        _authBtn.backgroundColor = UIColor.whiteColor;
        _authBtn.shouldRound = YES;
        _authBtn.font = MEDIUM_FONT(12);
        [_authBtn setTitleColor:HexRGB(0x25A1F0) forState:UIControlStateNormal];
        [_authBtn setTitleColor:HexRGB(0x25A1F0) forState:UIControlStateHighlighted];
        [_authBtn setTitle:@"去认证" forState:UIControlStateNormal];
    }
    return _authBtn;
}

@end
