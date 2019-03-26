//
//  ZYQuotaRecordCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/31.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYQuotaRecordCell.h"
#import "LimitRecord.h"

@interface ZYQuotaRecordCell()

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *amountLab;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) UILabel *timeLab;

@end

@implementation ZYQuotaRecordCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(26 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(43 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-21.5 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_LimitRecord *)model{
    self.titleLab.text = model.title;
    self.contentLab.text = model.content;
    if(model.recordType == 1){
        self.amountLab.text = [NSString stringWithFormat:@"+%.2f",model.amount];
        self.amountLab.textColor = WORD_COLOR_ORANGE;
    }else{
        self.amountLab.text = [NSString stringWithFormat:@"-%.2f",model.amount];
        self.amountLab.textColor = WORD_COLOR_BLACK;
    }
    self.timeLab.text = model.time;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = SEMIBOLD_FONT(16);
    }
    return _titleLab;
}

- (UILabel *)amountLab{
    if(!_amountLab){
        _amountLab = [UILabel new];
        _amountLab.font = SEMIBOLD_FONT(16);
    }
    return _amountLab;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_BLACK;
        _contentLab.font = FONT(14);
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.textColor = WORD_COLOR_GRAY_9B;
        _timeLab.font = FONT(12);
    }
    return _timeLab;
}

@end
