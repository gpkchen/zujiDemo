//
//  ZYOrderDetailInfoCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderDetailInfoCell.h"
#import "GetOrderDetail.h"

@interface ZYOrderDetailInfoCell ()

@property (nonatomic , strong) UILabel *numLab;
@property (nonatomic , strong) UILabel *timeLab;

@property (nonatomic , strong) UILabel *returnDateLab;
@property (nonatomic , strong) UILabel *leaseStartTimeLab;

@end

@implementation ZYOrderDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.cpBtn];
        [self.cpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(48 * UI_H_SCALE, 24 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.cpBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(40 * UI_H_SCALE);
            make.right.equalTo(self.cpBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.leaseStartTimeLab];
        [self.leaseStartTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(60 * UI_H_SCALE);
            make.right.equalTo(self.cpBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.returnDateLab];
        [self.returnDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(80 * UI_H_SCALE);
            make.right.equalTo(self.cpBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];

    }
    return self;
}

- (void)showCellWithModel:(_m_GetOrderDetail *)model{
    NSMutableAttributedString *num = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号：%@",model.orderId]];
    [num addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 5)];
    self.numLab.attributedText = num;
    
    NSMutableAttributedString *time = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"下单时间：%@",model.orderTime]];
    [time addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 5)];
    self.timeLab.attributedText = time;
    
    if (model.status == ZYOrderStateDone || model.status == ZYOrderStateUsing || model.status == ZYOrderStateMailedBack || model.status == ZYOrderStateAbnormal) {
        
        NSMutableAttributedString *leaseStartTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"起租时间：%@",model.leaseStartTime]];
        [leaseStartTime addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 5)];
        self.leaseStartTimeLab.attributedText = leaseStartTime;
        self.leaseStartTimeLab.hidden = NO;
        
        NSMutableAttributedString *returnDate = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"到期时间：%@",model.returnDate]];
        [returnDate addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 5)];
        self.returnDateLab.attributedText = returnDate;
        self.returnDateLab.hidden = NO;
        
    } else {
        
        self.leaseStartTimeLab.hidden = YES;
        self.returnDateLab.hidden = YES;
        
    }
    
   
    
    
}

#pragma mark - getter
- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.textColor = WORD_COLOR_GRAY;
        _numLab.font = FONT(12);
    }
    return _numLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.textColor = WORD_COLOR_GRAY;
        _timeLab.font = FONT(12);
    }
    return _timeLab;
}

- (UILabel *)returnDateLab{
    if(!_returnDateLab){
        _returnDateLab = [UILabel new];
        _returnDateLab.textColor = WORD_COLOR_GRAY;
        _returnDateLab.font = FONT(12);
    }
    return _returnDateLab;
}

- (UILabel *)leaseStartTimeLab{
    if(!_leaseStartTimeLab){
        _leaseStartTimeLab = [UILabel new];
        _leaseStartTimeLab.textColor = WORD_COLOR_GRAY;
        _leaseStartTimeLab.font = FONT(12);
    }
    return _leaseStartTimeLab;
}

- (ZYElasticButton *)cpBtn{
    if(!_cpBtn){
        _cpBtn = [ZYElasticButton new];
        _cpBtn.font = FONT(14);
        _cpBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _cpBtn.borderWidth = 1;
        _cpBtn.backgroundColor = [UIColor whiteColor];
        [_cpBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_cpBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_cpBtn setTitle:@"复制" forState:UIControlStateNormal];
    }
    return _cpBtn;
}

@end
