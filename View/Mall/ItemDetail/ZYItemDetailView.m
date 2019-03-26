//
//  ZYItemDetailView.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailView.h"

@interface ZYItemDetailView ()


@property (nonatomic , strong) UIView *toolBarBack;

@property (nonatomic , strong) UILabel *serviceLab;
@property (nonatomic , strong) UILabel *collectionLab;

@end

@implementation ZYItemDetailView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
        make.centerY.equalTo(self.mas_top).mas_offset(STATUSBAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT) / 2);
        make.size.mas_equalTo(CGSizeMake(31 * UI_H_SCALE, 31 * UI_H_SCALE));
    }];
    
    [self addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(DOWN_DANGER_HEIGHT + ZYItemDetailToolBarHeight);
    }];
    
    [self.toolBar addSubview:self.toolBarBack];
    [self.toolBarBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.toolBar);
        make.height.mas_equalTo(ZYItemDetailToolBarHeight);
    }];
    
    [self.toolBarBack addSubview:self.rentBtn];
    [self.rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.toolBarBack);
        make.width.mas_equalTo(150 * UI_H_SCALE);
    }];
    
    [self.toolBarBack addSubview:self.serviceBtn];
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.toolBarBack);
        make.width.mas_equalTo(82 * UI_H_SCALE);
    }];
    
    [self.toolBarBack addSubview:self.collectionBtn];
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.toolBarBack);
        make.width.mas_equalTo(82 * UI_H_SCALE);
        make.left.equalTo(self.serviceBtn.mas_right);
    }];
    
    [self.serviceBtn addSubview:self.serviceIcon];
    [self.serviceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.serviceBtn.mas_left).mas_offset(42.5 * UI_H_SCALE);
        make.centerY.equalTo(self.serviceBtn.mas_top).mas_offset(19 * UI_H_SCALE);
    }];
    
    [self.collectionBtn addSubview:self.collectionIcon];
    [self.collectionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionBtn.mas_left).mas_offset(25 * UI_H_SCALE);
        make.centerY.equalTo(self.collectionBtn.mas_top).mas_offset(19 * UI_H_SCALE);
    }];
    
    [self.serviceBtn addSubview:self.serviceLab];
    [self.serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.serviceIcon);
        make.centerY.equalTo(self.serviceBtn.mas_top).mas_offset(43.5 * UI_H_SCALE);
    }];
    
    [self.collectionBtn addSubview:self.collectionLab];
    [self.collectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionIcon);
        make.centerY.equalTo(self.collectionBtn.mas_top).mas_offset(43.5 * UI_H_SCALE);
    }];
}

#pragma mark - getter
- (UIView *)toolBar{
    if(!_toolBar){
        _toolBar = [UIView new];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}

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

- (ZYElasticButton *)rentBtn{
    if(!_rentBtn){
        _rentBtn = [ZYElasticButton new];
        _rentBtn.font = FONT(18);
        [_rentBtn setTitle:@"立即租" forState:UIControlStateNormal];
        _rentBtn.shouldAnimate = NO;
        [_rentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_rentBtn setTitleColor:WORD_COLOR_GRAY_AB forState:UIControlStateDisabled];
        [_rentBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_rentBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_rentBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
    }
    return _rentBtn;
}

- (ZYElasticButton *)backBtn{
    if(!_backBtn){
        _backBtn = [ZYElasticButton new];
        _backBtn.backgroundColor = [UIColor clearColor];
        _backBtn.cornerRadius = 31 * UI_H_SCALE / 2.0;
        _backBtn.clipsToBounds = YES;
        _backBtn.backgroundColor = HexRGBAlpha(0x7A7C80, 0.8);
        [_backBtn setImage:[UIImage imageNamed:@"zy_item_detail_back_btn"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"zy_item_detail_back_btn"] forState:UIControlStateHighlighted];
    }
    return _backBtn;
}

- (ZYElasticButton *)serviceBtn{
    if(!_serviceBtn){
        _serviceBtn = [ZYElasticButton new];
        _serviceBtn.backgroundColor = [UIColor whiteColor];
    }
    return _serviceBtn;
}

- (ZYElasticButton *)collectionBtn{
    if(!_collectionBtn){
        _collectionBtn = [ZYElasticButton new];
        _collectionBtn.backgroundColor = [UIColor whiteColor];
    }
    return _collectionBtn;
}

- (UIImageView *)serviceIcon{
    if(!_serviceIcon){
        _serviceIcon = [UIImageView new];
        _serviceIcon.image = [UIImage imageNamed:@"zy_mall_item_detail_service"];
    }
    return _serviceIcon;
}

- (UIImageView *)collectionIcon{
    if(!_collectionIcon){
        _collectionIcon = [UIImageView new];
        _collectionIcon.image = [UIImage imageNamed:@"zy_mall_item_detail_collection_normal"];
    }
    return _collectionIcon;
}

- (UILabel *)serviceLab{
    if(!_serviceLab){
        _serviceLab = [UILabel new];
        _serviceLab.textColor = WORD_COLOR_GRAY;
        _serviceLab.font = FONT(12);
        _serviceLab.text = @"在线客服";
    }
    return _serviceLab;
}

- (UILabel *)collectionLab{
    if(!_collectionLab){
        _collectionLab = [UILabel new];
        _collectionLab.textColor = WORD_COLOR_GRAY;
        _collectionLab.font = FONT(12);
        _collectionLab.text = @"收藏";
    }
    return _collectionLab;
}

@end
