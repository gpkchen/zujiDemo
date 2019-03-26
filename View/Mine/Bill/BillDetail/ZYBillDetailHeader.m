//
//  ZYBillDetailHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillDetailHeader.h"
#import "GetOrderBillDetail.h"

@interface ZYBillDetailHeader ()

//应还金额
@property (nonatomic , strong) UILabel *shouldPayLab;
@property (nonatomic , strong) UILabel *shouldPayTitleLab;

//已还金额
@property (nonatomic , strong) UILabel *payedLab;
@property (nonatomic , strong) UILabel *payedTitleLab;

//待还金额
@property (nonatomic , strong) UILabel *unpayLab;
@property (nonatomic , strong) UILabel *unpayTitleLab;

@property (nonatomic , strong) UILabel *noticeLab;

@end

@implementation ZYBillDetailHeader

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.shouldPayLab];
    [self.shouldPayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 3 * 0.5 - 3);
        make.centerY.equalTo(self.mas_top).mas_offset(32.5 * UI_H_SCALE);
    }];
    
    [self addSubview:self.shouldPayTitleLab];
    [self.shouldPayTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 3 * 0.5);
        make.centerY.equalTo(self.mas_top).mas_offset(55 * UI_H_SCALE);
    }];
    
    [self addSubview:self.payedLab];
    [self.payedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 3 * 1.5 - 3);
        make.centerY.equalTo(self.mas_top).mas_offset(32.5 * UI_H_SCALE);
    }];
    
    [self addSubview:self.payedTitleLab];
    [self.payedTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 3 * 1.5);
        make.centerY.equalTo(self.mas_top).mas_offset(55 * UI_H_SCALE);
    }];
    
    [self addSubview:self.unpayLab];
    [self.unpayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 3 * 2.5 - 3);
        make.centerY.equalTo(self.mas_top).mas_offset(32.5 * UI_H_SCALE);
    }];
    
    [self addSubview:self.unpayTitleLab];
    [self.unpayTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 3 * 2.5 );
        make.centerY.equalTo(self.mas_top).mas_offset(55 * UI_H_SCALE);
    }];
    
    [self addSubview:self.noticeLab];
    [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
        make.top.equalTo(self).mas_offset(80 * UI_H_SCALE);
    }];
}

- (void)showHeaderWithModel:(_m_GetOrderBillDetail *)model{
    self.shouldPayLab.text = [NSString stringWithFormat:@"￥%.2f",model.allRentPrice];
    self.payedLab.text = [NSString stringWithFormat:@"￥%.2f",model.haveRentPrice];
    self.unpayLab.text = [NSString stringWithFormat:@"￥%.2f",model.needRentPrice];
}

#pragma mark - getter
- (UILabel *)shouldPayLab{
    if(!_shouldPayLab){
        _shouldPayLab = [UILabel new];
        _shouldPayLab.textColor = MAIN_COLOR_GREEN;
        _shouldPayLab.font = FONT(18);
    }
    return _shouldPayLab;
}

- (UILabel *)shouldPayTitleLab{
    if(!_shouldPayTitleLab){
        _shouldPayTitleLab = [UILabel new];
        _shouldPayTitleLab.textColor = WORD_COLOR_BLACK;
        _shouldPayTitleLab.font = FONT(14);
        _shouldPayTitleLab.text = @"应付租金(元)";
    }
    return _shouldPayTitleLab;
}

- (UILabel *)payedLab{
    if(!_payedLab){
        _payedLab = [UILabel new];
        _payedLab.textColor = MAIN_COLOR_GREEN;
        _payedLab.font = FONT(18);
    }
    return _payedLab;
}

- (UILabel *)payedTitleLab{
    if(!_payedTitleLab){
        _payedTitleLab = [UILabel new];
        _payedTitleLab.textColor = WORD_COLOR_BLACK;
        _payedTitleLab.font = FONT(14);
        _payedTitleLab.text = @"已付租金(元)";
    }
    return _payedTitleLab;
}

- (UILabel *)unpayLab{
    if(!_unpayLab){
        _unpayLab = [UILabel new];
        _unpayLab.textColor = MAIN_COLOR_GREEN;
        _unpayLab.font = FONT(18);
    }
    return _unpayLab;
}

- (UILabel *)unpayTitleLab{
    if(!_unpayTitleLab){
        _unpayTitleLab = [UILabel new];
        _unpayTitleLab.textColor = WORD_COLOR_BLACK;
        _unpayTitleLab.font = FONT(14);
        _unpayTitleLab.text = @"待付租金(元)";
    }
    return _unpayTitleLab;
}

- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.textColor = WORD_COLOR_GRAY;
        _noticeLab.numberOfLines = 0;
        _noticeLab.lineBreakMode = NSLineBreakByCharWrapping;
        _noticeLab.font = FONT(12);
        _noticeLab.text = @"账单到期前将通过短信及系统推送告知你需付款,请注意查收信息";
    }
    return _noticeLab;
}

@end
