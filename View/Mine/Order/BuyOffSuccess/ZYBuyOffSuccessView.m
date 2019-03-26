//
//  ZYBuyOffSuccessView.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBuyOffSuccessView.h"

@interface ZYBuyOffSuccessView ()

@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation ZYBuyOffSuccessView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT + 55 * UI_H_SCALE);
    }];
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(27 * UI_H_SCALE);
    }];
    
    [self addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(75 * UI_H_SCALE);
        make.right.equalTo(self).mas_offset(-75 * UI_H_SCALE);
        make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(70 * UI_H_SCALE);
    }];
    
    [self addSubview:self.homeBtn];
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconIV.mas_bottom).mas_offset(128 * UI_H_SCALE);
        make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 32 * UI_H_SCALE));
    }];
}

#pragma mark - getter
- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"zy_order_buy_off_success_icon"];
    }
    return _iconIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(16);
        _titleLab.text = @"购买成功";
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_GRAY_AB;
        _contentLab.font = FONT(14);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLab;
}

- (ZYElasticButton *)homeBtn{
    if(!_homeBtn){
        _homeBtn = [ZYElasticButton new];
        _homeBtn.backgroundColor = VIEW_COLOR;
        _homeBtn.font = FONT(14);
        [_homeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [_homeBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_homeBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _homeBtn.shouldRound = YES;
        _homeBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _homeBtn.borderWidth = 1;
    }
    return _homeBtn;
}

@end
