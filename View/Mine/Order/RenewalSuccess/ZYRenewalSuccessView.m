//
//  ZYRenewalSuccessView.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYRenewalSuccessView.h"

@interface ZYRenewalSuccessView ()

@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UILabel *rentLab;

@property (nonatomic , strong) UIView *line1;
@property (nonatomic , strong) UIView *line2;

@property (nonatomic , strong) UILabel *termLab;
@property (nonatomic , strong) UILabel *termSubLab;

@end

@implementation ZYRenewalSuccessView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    CGFloat titleWidth = self.iconIV.image.size.width + 11 * UI_H_SCALE + self.titleLab.width;
    [self.contentView addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset((SCREEN_WIDTH - titleWidth) / 2.0);
        make.top.equalTo(self.contentView).mas_offset(40 * UI_H_SCALE);
        make.size.mas_equalTo(self.iconIV.image.size);
    }];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).mas_offset(11 * UI_H_SCALE);
        make.centerY.equalTo(self.iconIV);
    }];
    
    [self.contentView addSubview:self.rentLab];
    [self.rentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.centerY.equalTo(self.contentView.mas_top).mas_offset(162 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.rentLab.mas_bottom).mas_offset(18 * UI_H_SCALE);
        make.height.mas_equalTo(LINE_HEIGHT);
    }];
    
    [self.contentView addSubview:self.termLab];
    [self.termLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.top.equalTo(self.line1.mas_bottom).mas_offset(18 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.termSubLab];
    [self.termSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.top.equalTo(self.termLab.mas_bottom).mas_offset(9.5 * UI_H_SCALE);
        make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.termSubLab.mas_bottom).mas_offset(18 * UI_H_SCALE);
        make.height.mas_equalTo(LINE_HEIGHT);
    }];
    
    [self.contentView addSubview:self.orderBtn];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).mas_offset(30 * UI_H_SCALE);
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.contentView.mas_centerX).mas_offset(-12.5 * UI_H_SCALE);
        make.height.mas_equalTo(44 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.homeBtn];
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).mas_offset(30 * UI_H_SCALE);
        make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        make.left.equalTo(self.contentView.mas_centerX).mas_offset(12.5 * UI_H_SCALE);
        make.height.mas_equalTo(44 * UI_H_SCALE);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.homeBtn).mas_offset(50);
    }];
}

- (void)setRent:(NSString *)rent{
    _rent = rent;
    self.rentLab.text = rent;
}

- (void)setTerm:(NSString *)term{
    _term = term;
    self.termLab.text = term;
}

- (void)setTermSub:(NSString *)termSub{
    _termSub = termSub;
    self.termSubLab.text = termSub;
}

#pragma mark - getter
- (ZYScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [ZYScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.backgroundColor = [UIColor whiteColor];
        _iconIV.image = [UIImage imageNamed:@"zy_mall_pay_success_icon"];
    }
    return _iconIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(16);
        _titleLab.text = @"恭喜你续租成功";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UILabel *)rentLab{
    if(!_rentLab){
        _rentLab = [UILabel new];
        _rentLab.textColor = WORD_COLOR_BLACK;
        _rentLab.font = FONT(14);
    }
    return _rentLab;
}

- (UIView *)line1{
    if(!_line1){
        _line1 = [UIView new];
        _line1.backgroundColor = LINE_COLOR;
    }
    return _line1;
}

- (UIView *)line2{
    if(!_line2){
        _line2 = [UIView new];
        _line2.backgroundColor = LINE_COLOR;
    }
    return _line2;
}

- (UILabel *)termLab{
    if(!_termLab){
        _termLab = [UILabel new];
        _termLab.textColor = WORD_COLOR_BLACK;
        _termLab.font = FONT(14);
    }
    return _termLab;
}

- (UILabel *)termSubLab{
    if(!_termSubLab){
        _termSubLab = [UILabel new];
        _termSubLab.textColor = WORD_COLOR_GRAY;
        _termSubLab.font = FONT(12);
        _termSubLab.numberOfLines = 0;
        _termSubLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _termSubLab;
}

- (ZYElasticButton *)orderBtn{
    if(!_orderBtn){
        _orderBtn = [ZYElasticButton new];
        _orderBtn.font = FONT(16);
        [_orderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_orderBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _orderBtn.backgroundColor = [UIColor whiteColor];
        _orderBtn.shouldRound = YES;
        _orderBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _orderBtn.borderWidth = 1;
    }
    return _orderBtn;
}

- (ZYElasticButton *)homeBtn{
    if(!_homeBtn){
        _homeBtn = [ZYElasticButton new];
        _homeBtn.font = FONT(16);
        [_homeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [_homeBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_homeBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _homeBtn.shouldRound = YES;
        [_homeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _homeBtn;
}

@end
