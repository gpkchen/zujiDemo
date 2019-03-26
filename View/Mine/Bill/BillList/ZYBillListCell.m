//
//  ZYBillListCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillListCell.h"
#import "GetRepaymentBillList.h"

@interface ZYBillListCell ()

@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) UILabel *termLab;
@property (nonatomic , strong) UILabel *amountLab;
@property (nonatomic , strong) UILabel *stateLab;
@property (nonatomic , strong) UILabel *timeLab;

@end

@implementation ZYBillListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = VIEW_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [self.contentView bringSubviewToFront:self.separator];
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.backView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.backView addSubview:self.termLab];
        [self.termLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.backView.mas_top).mas_offset(41 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(98 * UI_H_SCALE);
            make.centerY.equalTo(self.termLab);
        }];
        
        [self.backView addSubview:self.stateLab];
        [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.termLab);
        }];
        
        [self.backView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.backView.mas_bottom).mas_offset(-16 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_GetRepaymentBillList_Bill *)model{
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
        self.stateLab.text = @"未支付";
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
    self.timeLab.text = model.repaymentDate;
}

#pragma mark - getter
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

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

@end
