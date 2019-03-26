//
//  ZYQuotaApnsAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/12.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYQuotaApnsAlert.h"

@interface ZYQuotaApnsAlert()

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UIView *hLine;
@property (nonatomic , strong) UIImageView *logoIV;

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *detailLab;
@property (nonatomic , strong) UILabel *amountLab;

@property (nonatomic , strong) ZYElasticButton *leftBtn;
@property (nonatomic , strong) ZYElasticButton *rightBtn;
@property (nonatomic , strong) UIView *vLine;

@end

@implementation ZYQuotaApnsAlert

- (instancetype)init{
    if(self = [super init]){
        [self.panel addSubview:self.hLine];
        [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.bottom.equalTo(self.panel).mas_offset(-69 * UI_H_SCALE);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.panel addSubview:self.logoIV];
        [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panel);
            make.top.equalTo(self.panel).mas_offset(30 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panel).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.panel).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.panel.mas_top).mas_offset(105 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panel);
            make.centerY.equalTo(self.panel.mas_top).mas_offset(132.5 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.detailLab];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panel).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.panel).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.panel.mas_top).mas_offset(149 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.panel);
            make.top.equalTo(self.hLine.mas_bottom);
            make.right.equalTo(self.panel.mas_centerX);
        }];
        
        [self.panel addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.panel);
            make.top.equalTo(self.hLine.mas_bottom);
            make.width.mas_equalTo(self.panel.width / 2.0);
        }];
        
        [self.panel addSubview:self.vLine];
        [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panel);
            make.centerY.equalTo(self.leftBtn);
            make.size.mas_equalTo(CGSizeMake(1, 15 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - public
- (void)showWithType:(ZYQuotaApnsAlertShowType)type amount:(double)amount{
    __weak __typeof__(self) weakSelf = self;
    if(type == ZYQuotaApnsAlertShowTypePassAuth){
        //通过认证无额度，不可提额
        self.titleLab.text = @"恭喜你通过信用审核，暂无免押额度开放";
        
        self.detailLab.text = @"（每次完成租赁履约，都将为你积累信用，有更多机会提高免押额度哦）";
        [self.detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.panel.mas_top).mas_offset(149 * UI_H_SCALE);
        }];
        
        self.amountLab.text = @"";
        
        self.leftBtn.hidden = YES;
        self.vLine.hidden = YES;
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.panel.width);
        }];
        [self.rightBtn setTitle:@"我知道啦" forState:UIControlStateNormal];
        [self.rightBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
        
    }else if(type == ZYQuotaApnsAlertShowTypePassGainAmount){
        //通过认证有额度，不可提额
        self.titleLab.text = @"恭喜你获得免押金额度";
        self.detailLab.text = @"";
        self.amountLab.text = [NSString stringWithFormat:@"%.0f元",amount];
        
        self.leftBtn.hidden = YES;
        self.vLine.hidden = YES;
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.panel.width);
        }];
        [self.rightBtn setTitle:@"我知道啦" forState:UIControlStateNormal];
        [self.rightBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
        
    }else if(type == ZYQuotaApnsAlertShowTypePassAuthImprove){
        //通过认证无额度，可以提额
        self.titleLab.text = @"恭喜你通过信用审核，暂无免押额度开放";
        
        self.detailLab.text = @"悄悄告诉你：\n完成租赁履约，积累信用可以提额哦；\n认证更多信息也可以提高额度。";
        [self.detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.panel.mas_top).mas_offset(149 * UI_H_SCALE);
        }];
        
        self.amountLab.text = @"";
        
        self.leftBtn.hidden = NO;
        self.vLine.hidden = NO;
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.panel.width / 2.0);
        }];
        [self.rightBtn setTitle:@"去提额" forState:UIControlStateNormal];
        [self.rightBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goWithoutHead:@"limit"];
            [weakSelf dismiss];
        }];
        
    }else if(type == ZYQuotaApnsAlertShowTypePassGainAmountImprove){
        //通过认证有额度，可以提额
        self.titleLab.text = @"恭喜你获得免押金额度";
        
        self.detailLab.text = @"完成更多认证，获得更高额度";
        [self.detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.panel.mas_top).mas_offset(158.5 * UI_H_SCALE);
        }];
        
        self.amountLab.text = [NSString stringWithFormat:@"%.0f元",amount];
        
        self.leftBtn.hidden = NO;
        self.vLine.hidden = NO;
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.panel.width / 2.0);
        }];
        [self.rightBtn setTitle:@"去提额" forState:UIControlStateNormal];
        [self.rightBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goWithoutHead:@"limit"];
            [weakSelf dismiss];
        }];
    }
    [super showWithPanelView:self.panel];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.backgroundColor = UIColor.whiteColor;
        _panel.cornerRadius = 8;
        _panel.size = CGSizeMake(300 * UI_H_SCALE, 255 * UI_H_SCALE);
    }
    return _panel;
}

- (UIView *)hLine{
    if(!_hLine){
        _hLine = [UIView new];
        _hLine.backgroundColor = LINE_COLOR;
    }
    return _hLine;
}

- (UIImageView *)logoIV{
    if(!_logoIV){
        _logoIV = [UIImageView new];
        _logoIV.image = [UIImage imageNamed:@"zy_quota_apns_success"];
    }
    return _logoIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = FONT(14);
        _titleLab.numberOfLines = 2;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    }
    return _titleLab;
}

- (UILabel *)detailLab{
    if(!_detailLab){
        _detailLab = [UILabel new];
        _detailLab.textColor = WORD_COLOR_GRAY;
        _detailLab.textAlignment = NSTextAlignmentCenter;
        _detailLab.font = FONT(12);
        _detailLab.numberOfLines = 3;
        _detailLab.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    }
    return _detailLab;
}

- (UILabel *)amountLab{
    if(!_amountLab){
        _amountLab = [UILabel new];
        _amountLab.textColor = MAIN_COLOR_GREEN;
        _amountLab.font = FONT(24);
    }
    return _amountLab;
}

- (ZYElasticButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [ZYElasticButton new];
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn setTitle:@"我知道啦" forState:UIControlStateNormal];
        _leftBtn.font = FONT(15);
        [_leftBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_leftBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_leftBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
    }
    return _leftBtn;
}

- (ZYElasticButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [ZYElasticButton new];
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn setTitle:@"去提额" forState:UIControlStateNormal];
        _rightBtn.font = FONT(15);
        [_rightBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _rightBtn;
}

- (UIView *)vLine{
    if(!_vLine){
        _vLine = [UIView new];
        _vLine.backgroundColor = LINE_COLOR;
    }
    return _vLine;
}

@end
