//
//  ZYPayBar.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPayBar.h"

#define kZYPayBarHeight (55 * UI_H_SCALE)

@interface ZYPayBar()

@property (nonatomic , strong) UIView *toolBarBack;
@property (nonatomic , strong) UILabel *priceLab;
@property (nonatomic , strong) UILabel *limitLab;

@end

@implementation ZYPayBar

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        _priceTitle = @"共计";
        _isMinLimit = YES;
        
        [self addSubview:self.toolBarBack];
        [self.toolBarBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kZYPayBarHeight);
        }];
        
        [self addSubview:self.payBtn];
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.width.mas_equalTo(150 * UI_H_SCALE);
            make.bottom.equalTo(self).mas_offset(-DOWN_DANGER_HEIGHT);
        }];
        
        [self addSubview:self.priceLab];
        
        [self addSubview:self.limitLab];
        [self.limitLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolBarBack).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.toolBarBack.mas_bottom).mas_offset(-15.5 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setPrice:(double)price{
    _price = price;
    
    if(_isMinLimit){
        if(price < 0.01){
            price = 0.01;
            self.limitLab.hidden = NO;
            [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.toolBarBack).mas_offset(15 * UI_H_SCALE);
                make.centerY.equalTo(self.toolBarBack.mas_top).mas_offset(20.5 * UI_H_SCALE);
            }];
        }else{
            self.limitLab.hidden = YES;
            [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.toolBarBack).mas_offset(15 * UI_H_SCALE);
                make.centerY.equalTo(self.toolBarBack);
            }];
        }
    }else{
        self.limitLab.hidden = YES;
        [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolBarBack).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.toolBarBack);
        }];
    }
    NSString *str = [NSString stringWithFormat:@"%@：￥%.2f",_priceTitle,price];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, _priceTitle.length + 1)];
    [att addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, _priceTitle.length + 1)];
    self.priceLab.attributedText = att;
}

#pragma mark - getter
- (UIView *)toolBarBack{
    if(!_toolBarBack){
        _toolBarBack = [UIView new];
        _toolBarBack.backgroundColor = [UIColor whiteColor];
        _toolBarBack.layer.shadowColor = [UIColor blackColor].CGColor;
        _toolBarBack.layer.shadowOpacity = 0.05;
        _toolBarBack.layer.shadowOffset = CGSizeMake(0, -1);
    }
    return _toolBarBack;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_ORANGE;
        _priceLab.font = MEDIUM_FONT(18);
    }
    return _priceLab;
}

- (UILabel *)limitLab{
    if(!_limitLab){
        _limitLab = [UILabel new];
        _limitLab.textColor = WORD_COLOR_GRAY_AB;
        _limitLab.font = FONT(12);
        _limitLab.text = @"最小支付金额：0.01元";
        _limitLab.hidden = YES;
    }
    return _limitLab;
}

- (ZYElasticButton *)payBtn{
    if(!_payBtn){
        _payBtn = [ZYElasticButton new];
        _payBtn.font = FONT(18);
        [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _payBtn.shouldAnimate = NO;
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_payBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _payBtn;
}

@end
