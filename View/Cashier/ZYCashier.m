//
//  ZYCashier.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCashier.h"

@interface ZYCashier ()

@property (nonatomic , strong) UIView *panel;

@property (nonatomic , strong) ZYElasticButton *alipayBtn;
@property (nonatomic , strong) UIImageView *alipayIconIV;
@property (nonatomic , strong) UIImageView *alipaySelectionIV;
@property (nonatomic , strong) UILabel *alipayLab;

@property (nonatomic , strong) ZYElasticButton *wechatBtn;
@property (nonatomic , strong) UIImageView *wechatIconIV;
@property (nonatomic , strong) UIImageView *wechatSelectionIV;
@property (nonatomic , strong) UILabel *wechatLab;

@property (nonatomic , strong) UIView *line;

@end

@implementation ZYCashier

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    [self.panel addSubview:self.alipayBtn];
    [self.alipayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.panel);
        make.height.mas_equalTo(60 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.wechatBtn];
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.panel);
        make.height.mas_equalTo(60 * UI_H_SCALE);
        make.top.equalTo(self.alipayBtn.mas_bottom);
    }];
    
    [self.panel addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.panel);
        make.top.equalTo(self.panel).mas_offset(60 * UI_H_SCALE);
        make.height.mas_equalTo(LINE_HEIGHT);
    }];
    
    [self.alipayBtn addSubview:self.alipayIconIV];
    [self.alipayIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipayBtn).mas_offset(15 * UI_H_SCALE);
        make.centerY.equalTo(self.alipayBtn);
    }];
    
    [self.alipayBtn addSubview:self.alipaySelectionIV];
    [self.alipaySelectionIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.right.equalTo(self.alipayBtn).mas_offset(-15 * UI_H_SCALE);
        make.centerY.equalTo(self.alipayBtn);
    }];
    
    [self.wechatBtn addSubview:self.wechatIconIV];
    [self.wechatIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatBtn).mas_offset(15 * UI_H_SCALE);
        make.centerY.equalTo(self.wechatBtn);
    }];
    
    [self.wechatBtn addSubview:self.wechatSelectionIV];
    [self.wechatSelectionIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.right.equalTo(self.wechatBtn).mas_offset(-15 * UI_H_SCALE);
        make.centerY.equalTo(self.wechatBtn);
    }];
    
    [self.alipayBtn addSubview:self.alipayLab];
    [self.alipayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipayIconIV.mas_right).mas_offset(20 * UI_H_SCALE);
        make.centerY.equalTo(self.alipayBtn);
    }];
    
    [self.wechatBtn addSubview:self.wechatLab];
    [self.wechatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatIconIV.mas_right).mas_offset(20 * UI_H_SCALE);
        make.centerY.equalTo(self.wechatBtn);
    }];
}

#pragma mark - public
- (void)show{
    self.panelView = self.panel;
    [super show];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.backgroundColor = [UIColor whiteColor];
        _panel.size = CGSizeMake(SCREEN_WIDTH, 120 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }
    return _panel;
}

- (ZYElasticButton *)alipayBtn{
    if(!_alipayBtn){
        _alipayBtn = [ZYElasticButton new];
        _alipayBtn.shouldAnimate = NO;
        _alipayBtn.backgroundColor = [UIColor whiteColor];
        
        __weak __typeof__(self) weakSelf = self;
        [_alipayBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.action ? : weakSelf.action(ZYPaymentTypeAlipay);
        }];
    }
    return _alipayBtn;
}

- (ZYElasticButton *)wechatBtn{
    if(!_wechatBtn){
        _wechatBtn = [ZYElasticButton new];
        _wechatBtn.shouldAnimate = NO;
        _wechatBtn.backgroundColor = [UIColor whiteColor];
        
        __weak __typeof__(self) weakSelf = self;
        [_wechatBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.action ? : weakSelf.action(ZYPaymentTypeWechat);
        }];
    }
    return _wechatBtn;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UIImageView *)alipayIconIV{
    if(!_alipayIconIV){
        _alipayIconIV = [UIImageView new];
        _alipayIconIV.image = [UIImage imageNamed:@"zy_cashier_alipay"];
    }
    return _alipayIconIV;
}

- (UIImageView *)wechatIconIV{
    if(!_wechatIconIV){
        _wechatIconIV = [UIImageView new];
        _wechatIconIV.image = [UIImage imageNamed:@"zy_cashier_wechat"];
    }
    return _wechatIconIV;
}

- (UIImageView *)alipaySelectionIV{
    if(!_alipaySelectionIV){
        _alipaySelectionIV = [UIImageView new];
//        _alipaySelectionIV.image = [UIImage imageNamed:@"zy_selection_selected"];
    }
    return _alipaySelectionIV;
}

- (UIImageView *)wechatSelectionIV{
    if(!_wechatSelectionIV){
        _wechatSelectionIV = [UIImageView new];
    }
    return _wechatSelectionIV;
}

- (UILabel *)alipayLab{
    if(!_alipayLab){
        _alipayLab = [UILabel new];
        _alipayLab.textColor = WORD_COLOR_BLACK;
        _alipayLab.font = FONT(16);
        _alipayLab.text = @"支付宝支付";
    }
    return _alipayLab;
}

- (UILabel *)wechatLab{
    if(!_wechatLab){
        _wechatLab = [UILabel new];
        _wechatLab.textColor = WORD_COLOR_BLACK;
        _wechatLab.font = FONT(16);
        _wechatLab.text = @"微信支付";
    }
    return _wechatLab;
}

@end
