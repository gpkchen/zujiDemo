
//
//  ZYExchangeCouponView.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYExchangeCouponView.h"

@interface ZYExchangeCouponView()

@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *btnLab;
@property (nonatomic , strong) UIImageView *btnIV;

@end

@implementation ZYExchangeCouponView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.exchangeBtn];
        [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).mas_offset(-DOWN_DANGER_HEIGHT);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self.exchangeBtn.mas_top);
        }];
        
        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.contentView addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).mas_offset(124 * UI_H_SCALE + NAVIGATION_BAR_HEIGHT);
        }];
        
        [self.contentView addSubview:self.codeText];
        [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.iconIV.mas_bottom).mas_offset(20 * UI_H_SCALE);
            make.height.mas_equalTo(60 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(30 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-30 * UI_H_SCALE);
            make.bottom.equalTo(self.codeText);
            make.height.mas_equalTo(1);
        }];
        
        [self.contentView addSubview:self.ruleBtn];
        [self.ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).mas_offset(SCREEN_HEIGHT - DOWN_DANGER_HEIGHT - 145 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(100 * UI_H_SCALE, 50 * UI_H_SCALE));
        }];
        
        [self.ruleBtn addSubview:self.btnLab];
        [self.btnLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.ruleBtn);
        }];
        
        [self.ruleBtn addSubview:self.btnIV];
        [self.btnIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnLab);
            make.left.equalTo(self.btnLab.mas_right).mas_offset(3);
        }];
        
        [self.contentView addSubview:self.errorLab];
        [self.errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.codeText.mas_bottom).mas_offset(30 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.ruleBtn).mas_offset(30 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [ZYScrollView new];
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
        
        __weak __typeof__(self) weakSelf = self;
        [_scrollView tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf endEditing:YES];
        } delegate:nil];
    }
    return _scrollView;
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"zy_exchange_coupon_icon"];
    }
    return _iconIV;
}

- (ZYTextField *)codeText{
    if(!_codeText){
        _codeText = [ZYTextField new];
        _codeText.placeholder = @"请输入你的兑换码";
        _codeText.textColor = WORD_COLOR_BLACK;
        _codeText.placeholderColor = WORD_COLOR_GRAY_AB;
        _codeText.font = FONT(15);
        _codeText.wordLimitNum = 8;
        _codeText.textAlignment = NSTextAlignmentCenter;
    }
    return _codeText;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (ZYElasticButton *)exchangeBtn{
    if(!_exchangeBtn){
        _exchangeBtn = [ZYElasticButton new];
        _exchangeBtn.font = FONT(15);
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        [_exchangeBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_exchangeBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_exchangeBtn setBackgroundColor:BTN_COLOR_DISABLE_GREEN forState:UIControlStateDisabled];
        _exchangeBtn.enabled = NO;
    }
    return _exchangeBtn;
}

-(ZYElasticButton *)ruleBtn{
    if(!_ruleBtn){
        _ruleBtn = [ZYElasticButton new];
        _ruleBtn.backgroundColor = UIColor.whiteColor;
    }
    return _ruleBtn;
}

- (UILabel *)btnLab{
    if(!_btnLab){
        _btnLab = [UILabel new];
        _btnLab.textColor = WORD_COLOR_BLACK;
        _btnLab.font = FONT(15);
        _btnLab.text = @"兑换规则";
    }
    return _btnLab;
}

- (UIImageView *)btnIV{
    if(!_btnIV){
        _btnIV = [UIImageView new];
        _btnIV.image = [UIImage imageNamed:@"zy_mine_all_order_arrow"];
    }
    return _btnIV;
}

- (UILabel *)errorLab{
    if(!_errorLab){
        _errorLab = [UILabel new];
        _errorLab.textColor = WORD_COLOR_ORANGE;
        _errorLab.numberOfLines = 0;
        _errorLab.textAlignment = NSTextAlignmentCenter;
    }
    return _errorLab;
}

@end
