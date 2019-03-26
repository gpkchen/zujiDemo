//
//  ZYBillListHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillListHeader.h"
#import "GetRepaymentBillList.h"

@interface ZYBillListHeader ()

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIView *downBackView;
@property (nonatomic , strong) UIView *openBtnBack;
@property (nonatomic , strong) UIImageView *downArrowIV;
@property (nonatomic , strong) UIView *separator;
@property (nonatomic , strong) UIImageView *arrowIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *termLab;
@property (nonatomic , strong) UILabel *priceLab;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UILabel *stateLab;

@end

@implementation ZYBillListHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = VIEW_COLOR;
        self.size = CGSizeMake(SCREEN_WIDTH, ZYBillListHeaderHeight);
//        self.clipsToBounds = YES;
//        self.contentView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.downBackView];
        [self.downBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.openBtnBack];
        [self.openBtnBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.size.mas_equalTo(self.openBtnBack.size);
        }];
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.openBtn];
        [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.size.mas_equalTo(self.openBtn.size);
        }];
        
        [self.contentView addSubview:self.downArrowIV];
        [self.downArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.openBtn);
            make.bottom.equalTo(self.backView);
        }];
        
        [self.contentView addSubview:self.separator];
        [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(42 * UI_H_SCALE);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.detailBtn];
        [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.bottom.equalTo(self.separator.mas_top);
        }];
        
        [self.contentView addSubview:self.arrowIV];
        [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(21 * UI_H_SCALE);
            make.size.mas_equalTo(self.arrowIV.image.size);
        }];
        
        [self.contentView addSubview:self.termLab];
        [self.termLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowIV.mas_left).mas_offset(-5 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(21 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(21 * UI_H_SCALE);
            make.right.equalTo(self.termLab.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(62.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(90 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.stateLab];
        [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLab.mas_right).mas_offset(4 * UI_H_SCALE);
            make.centerY.equalTo(self.timeLab);
        }];
        
        [self.contentView addSubview:self.payBtn];
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-32 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(80.5 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(88 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
    }
    return self;
}

- (void)showHeaderWithModel:(_m_GetRepaymentBillList *)model{
    self.titleLab.text = model.title;
    if(model.rentType == ZYRentTypeLong){
        self.termLab.text = [NSString stringWithFormat:@"[%d/%d期]",model.nowRentPeriod,model.allRentPeriod];
    }else{
        self.termLab.text = [NSString stringWithFormat:@"[%d/%d]",model.nowRentPeriod,model.allRentPeriod];
    }
    [self.termLab sizeToFit];
    [self.termLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.termLab.size);
    }];
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",model.rentPrice];
    self.timeLab.text = [NSString stringWithFormat:@"账单日:%@",model.repaymentDate];
    if(model.billStatus == ZYBillStateOverdue){
        self.stateLab.text = @"已逾期";
        self.stateLab.textColor = HexRGB(0xFF4500);
        self.payBtn.hidden = NO;
    }else if(model.billStatus == ZYBillStateWaitPay){
        self.stateLab.text = @"未支付";
        self.stateLab.textColor = HexRGB(0xFF4500);
        self.payBtn.hidden = NO;
    }else if(model.billStatus == ZYBillStatePayedOverdue || model.billStatus == ZYBillStatePayedNormal){
        self.stateLab.text = @"已支付";
        self.stateLab.textColor = MAIN_COLOR_GREEN;
        self.payBtn.hidden = YES;
    }else if(model.billStatus == ZYBillStateCanceled){
        self.stateLab.text = @"已取消";
        self.stateLab.textColor = WORD_COLOR_GRAY_AB;
    }
    
    if(model.rentType == ZYRentTypeShort){
        self.openBtn.hidden = YES;
        self.downArrowIV.hidden = YES;
    }else{
        self.openBtn.hidden = NO;
        self.downArrowIV.hidden = NO;
    }
    
}

#pragma mark - setter
- (void)setIsOpened:(BOOL)isOpened{
    _isOpened = isOpened;
    if(isOpened){
        self.downArrowIV.transform = CGAffineTransformMakeRotation(M_PI);
        self.downBackView.hidden = NO;
        self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.openBtnBack.layer.shadowColor = [UIColor blackColor].CGColor;
    }else{
        self.downArrowIV.transform = CGAffineTransformMakeRotation(0);
        self.downBackView.hidden = YES;
        self.backView.layer.shadowColor = [UIColor clearColor].CGColor;
        self.openBtnBack.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

#pragma mark - getter
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.shadowOpacity = 0.05;
        _backView.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return _backView;
}

- (UIView *)openBtnBack{
    if(!_openBtnBack){
        _openBtnBack = [UIView new];
        _openBtnBack.backgroundColor = [UIColor whiteColor];
        _openBtnBack.size = CGSizeMake(40, 40);
        _openBtnBack.cornerRadius = 20;
        _openBtnBack.layer.shadowOpacity = 0.05;
        _openBtnBack.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return _openBtnBack;
}

- (UIView *)downBackView{
    if(!_downBackView){
        _downBackView = [UIView new];
        _downBackView.backgroundColor = [UIColor whiteColor];
    }
    return _downBackView;
}

- (UIImageView *)downArrowIV{
    if(!_downArrowIV){
        _downArrowIV = [UIImageView new];
        _downArrowIV.image = [UIImage imageNamed:@"zy_arrow_down"];
    }
    return _downArrowIV;
}

- (ZYElasticButton *)openBtn{
    if(!_openBtn){
        _openBtn = [ZYElasticButton new];
        _openBtn.backgroundColor = [UIColor whiteColor];
        _openBtn.size = CGSizeMake(40, 40);
        _openBtn.cornerRadius = 20;
    }
    return _openBtn;
}

- (ZYElasticButton *)detailBtn{
    if(!_detailBtn){
        _detailBtn = [ZYElasticButton new];
        _detailBtn.backgroundColor = [UIColor whiteColor];
    }
    return _detailBtn;
}

- (UIImageView *)arrowIV{
    if(!_arrowIV){
        _arrowIV = [UIImageView new];
        _arrowIV.image = [UIImage imageNamed:@"zy_basic_cell_arrow_navy"];
    }
    return _arrowIV;
}

- (UIView *)separator{
    if(!_separator){
        _separator = [UIImageView new];
        _separator.backgroundColor = LINE_COLOR;
    }
    return _separator;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(14);
    }
    return _titleLab;
}

- (UILabel *)termLab{
    if(!_termLab){
        _termLab = [UILabel new];
        _termLab.textColor = WORD_COLOR_BLACK;
        _termLab.font = FONT(14);
    }
    return _termLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = [UIColor blackColor];
        _priceLab.font = MEDIUM_FONT(18);
    }
    return _priceLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.textColor = WORD_COLOR_BLACK;
        _timeLab.font = FONT(14);
    }
    return _timeLab;
}

- (UILabel *)stateLab{
    if(!_stateLab){
        _stateLab = [UILabel new];
        _stateLab.font = FONT(14);
    }
    return _stateLab;
}

- (ZYElasticButton *)payBtn{
    if(!_payBtn){
        _payBtn = [ZYElasticButton new];
        _payBtn.borderColor = HexRGB(0x1CBD4C);
        _payBtn.borderWidth = LINE_HEIGHT;
        _payBtn.cornerRadius = 16 * UI_H_SCALE;
        _payBtn.font = FONT(14);
        [_payBtn setTitle:@"支付本期" forState:UIControlStateNormal];
        [_payBtn setTitle:@"支付本期" forState:UIControlStateHighlighted];
        [_payBtn setTitleColor:HexRGB(0x1CBD4C) forState:UIControlStateNormal];
        [_payBtn setTitleColor:HexRGB(0x1CBD4C) forState:UIControlStateHighlighted];
    }
    return _payBtn;
}

@end
