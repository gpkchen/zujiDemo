//
//  ZYPaySuccessView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPaySuccessView.h"

@interface ZYPaySuccessView ()

@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UILabel *rentLab;

@property (nonatomic , strong) UIView *line1;
@property (nonatomic , strong) UIView *line2;
@property (nonatomic , strong) UIView *line3;

@property (nonatomic , strong) UILabel *termLab;
@property (nonatomic , strong) UILabel *termSubLab;

@property (nonatomic , strong) UILabel *depositLab;
@property (nonatomic , strong) UILabel *depositSubLab;

@end

@implementation ZYPaySuccessView

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
        make.centerY.equalTo(self.contentView.mas_top).mas_offset(53 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).mas_offset(11 * UI_H_SCALE);
        make.centerY.equalTo(self.contentView.mas_top).mas_offset(77 * UI_H_SCALE);
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
    
    [self.contentView addSubview:self.depositLab];
    [self.depositLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.top.equalTo(self.line2.mas_bottom).mas_offset(18 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.depositSubLab];
    [self.depositSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        make.top.equalTo(self.depositLab.mas_bottom).mas_offset(9.5 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.line3];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.depositSubLab.mas_bottom).mas_offset(18 * UI_H_SCALE);
        make.height.mas_equalTo(LINE_HEIGHT);
    }];
    
    [self.contentView addSubview:self.orderBtn];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3.mas_bottom).mas_offset(30 * UI_H_SCALE);
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.contentView.mas_centerX).mas_offset(-12.5 * UI_H_SCALE);
        make.height.mas_equalTo(44 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.homeBtn];
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3.mas_bottom).mas_offset(30 * UI_H_SCALE);
        make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        make.left.equalTo(self.contentView.mas_centerX).mas_offset(12.5 * UI_H_SCALE);
        make.height.mas_equalTo(44 * UI_H_SCALE);
    }];
    
    [self.contentView addSubview:self.banner];
    [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderBtn.mas_bottom).mas_offset(42 * UI_H_SCALE);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(100 * UI_H_SCALE);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.banner).mas_offset(50);
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

- (void)setDeposit:(NSString *)deposit{
    _deposit = deposit;
    self.depositLab.text = deposit;
}

- (void)setDepositSub:(NSString *)depositSub{
    _depositSub = depositSub;
    self.depositSubLab.text = depositSub;
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
        _titleLab.text = @"恭喜你下单成功";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab{
    if(!_subTitleLab){
        _subTitleLab = [UILabel new];
        _subTitleLab.textColor = WORD_COLOR_GRAY;
        _subTitleLab.font = FONT(12);
        _subTitleLab.text = @"我们将尽快为你配送";
        [_subTitleLab sizeToFit];
    }
    return _subTitleLab;
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

- (UIView *)line3{
    if(!_line3){
        _line3 = [UIView new];
        _line3.backgroundColor = LINE_COLOR;
    }
    return _line3;
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

- (UILabel *)depositLab{
    if(!_depositLab){
        _depositLab = [UILabel new];
        _depositLab.textColor = WORD_COLOR_BLACK;
        _depositLab.font = FONT(14);
    }
    return _depositLab;
}

- (UILabel *)depositSubLab{
    if(!_depositSubLab){
        _depositSubLab = [UILabel new];
        _depositSubLab.textColor = WORD_COLOR_GRAY;
        _depositSubLab.font = FONT(12);
        _depositSubLab.numberOfLines = 0;
        _depositSubLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _depositSubLab;
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

- (SDCycleScrollView *)banner{
    if(!_banner){
        _banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:nil];
        _banner.autoScrollTimeInterval = 3;
        _banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _banner.showPageControl = YES;
        _banner.currentPageDotColor = MAIN_COLOR_GREEN;
        _banner.backgroundColor = [UIColor whiteColor];
    }
    return _banner;
}

@end
