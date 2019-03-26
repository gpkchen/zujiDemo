//
//  ZYBillDetailCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillDetailCell.h"
#import "GetOrderBillDetail.h"

@interface ZYBillDetailCell ()

@property (nonatomic , strong) UILabel *termLab;
@property (nonatomic , strong) UILabel *amountLab;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UILabel *stateLab;

@end

@implementation ZYBillDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.termLab];
        [self.termLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(31 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(115 * UI_H_SCALE);
            make.centerY.equalTo(self.termLab);
        }];
        
        [self.contentView addSubview:self.payBtn];
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.termLab);
            make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.stateLab];
        [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.termLab);
        }];
        
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.termLab);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(53 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_GetOrderBillDetail_Bill *)model{
    if(model.rentType == ZYRentTypeLong){
        self.termLab.text = [NSString stringWithFormat:@"[%d/%d期]",model.nowRentPeriod,model.allRentPeriod];
    }else{
        self.termLab.text = [NSString stringWithFormat:@"[%d/%d]",model.nowRentPeriod,model.allRentPeriod];
    }
    self.amountLab.text = [NSString stringWithFormat:@"￥%.2f",model.rentPrice];
    if(model.billStatus == ZYBillStateOverdue){
        self.stateLab.text = @"已逾期";
        self.termLab.textColor = WORD_COLOR_BLACK;
        self.amountLab.textColor = WORD_COLOR_BLACK;
        self.stateLab.textColor = WORD_COLOR_BLACK;
        self.timeLab.textColor = WORD_COLOR_GRAY;
    }else if(model.billStatus == ZYBillStateWaitPay){
        self.stateLab.text = @"待支付";
        self.termLab.textColor = WORD_COLOR_BLACK;
        self.amountLab.textColor = WORD_COLOR_BLACK;
        self.stateLab.textColor = WORD_COLOR_BLACK;
        self.timeLab.textColor = WORD_COLOR_GRAY;
    }else if(model.billStatus == ZYBillStatePayedOverdue || model.billStatus == ZYBillStatePayedNormal){
        self.stateLab.text = @"已支付";
        self.termLab.textColor = WORD_COLOR_GRAY_AB;
        self.amountLab.textColor = WORD_COLOR_GRAY_AB;
        self.stateLab.textColor = WORD_COLOR_GRAY_AB;
        self.timeLab.textColor = WORD_COLOR_GRAY_AB;
    }else if(model.billStatus == ZYBillStateCanceled){
        self.stateLab.text = @"已取消";
        self.termLab.textColor = WORD_COLOR_GRAY_AB;
        self.amountLab.textColor = WORD_COLOR_GRAY_AB;
        self.stateLab.textColor = WORD_COLOR_GRAY_AB;
        self.timeLab.textColor = WORD_COLOR_GRAY_AB;
    }
    if(model.isAllowPay){
        self.payBtn.hidden = NO;
        self.stateLab.hidden = YES;
    }else{
        self.payBtn.hidden = YES;
        self.stateLab.hidden = NO;
    }
    self.timeLab.text = model.repaymentDate;
}

#pragma mark - getter
- (UILabel *)termLab{
    if(!_termLab){
        _termLab = [UILabel new];
        _termLab.font = FONT(14);
        _termLab.textColor = WORD_COLOR_BLACK;
    }
    return _termLab;
}

- (UILabel *)amountLab{
    if(!_amountLab){
        _amountLab = [UILabel new];
        _amountLab.font = MEDIUM_FONT(18);
        _amountLab.textColor = WORD_COLOR_BLACK;
    }
    return _amountLab;
}

- (UILabel *)stateLab{
    if(!_stateLab){
        _stateLab = [UILabel new];
        _stateLab.font = FONT(16);
        _stateLab.textColor = WORD_COLOR_BLACK;
    }
    return _stateLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.font = FONT(14);
        _timeLab.textColor = WORD_COLOR_GRAY;
    }
    return _timeLab;
}

- (ZYElasticButton *)payBtn{
    if(!_payBtn){
        _payBtn = [ZYElasticButton new];
        _payBtn.shouldRound = YES;
        [_payBtn setTitle:@"支付本期" forState:UIControlStateNormal];
        [_payBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_payBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _payBtn.font = FONT(16);
        _payBtn.backgroundColor = [UIColor whiteColor];
        _payBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _payBtn.borderWidth = 1;
    }
    return _payBtn;
}

@end
