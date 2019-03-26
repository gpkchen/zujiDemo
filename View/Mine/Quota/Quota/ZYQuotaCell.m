//
//  ZYQuotaCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYQuotaCell.h"

@implementation ZYQuotaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.logoIV];
        [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.authBtn];
        [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoIV.mas_right).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(34 * UI_H_SCALE);
            make.right.lessThanOrEqualTo(self.authBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.detailLab];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoIV.mas_right).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(56.5 * UI_H_SCALE);
            make.right.lessThanOrEqualTo(self.authBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)logoIV{
    if(!_logoIV){
        _logoIV = [UIImageView new];
    }
    return _logoIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(16);
    }
    return _titleLab;
}

- (UILabel *)detailLab{
    if(!_detailLab){
        _detailLab = [UILabel new];
        _detailLab.textColor = WORD_COLOR_GRAY;
        _detailLab.font = FONT(12);
    }
    return _detailLab;
}

- (ZYElasticButton *)authBtn{
    if(!_authBtn){
        _authBtn = [ZYElasticButton new];
        _authBtn.backgroundColor = [UIColor whiteColor];
        _authBtn.font = FONT(12);
        [_authBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_authBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_authBtn setTitleColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        [_authBtn setTitle:@"去认证" forState:UIControlStateNormal];
        [_authBtn setTitle:@"已认证" forState:UIControlStateDisabled];
        _authBtn.cornerRadius = 15 * UI_H_SCALE;
        _authBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _authBtn.borderWidth = 1;
    }
    return _authBtn;
}

@end
