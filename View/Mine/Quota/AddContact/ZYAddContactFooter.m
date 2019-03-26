//
//  ZYContactFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddContactFooter.h"

@interface ZYAddContactFooter()

@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UIView *btnBack;
@property (nonatomic , strong) UILabel *noticeLab;

@end

@implementation ZYAddContactFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self addSubview:self.btnBack];
        [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.equalTo(self.line.mas_bottom);
            make.height.mas_equalTo(49);
        }];
        
        [self.btnBack addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.btnBack);
            make.left.mas_equalTo(self.btnBack).mas_offset(10 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, 49));
        }];
        
        [self.btnBack addSubview:self.midBtn];
        [self.midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.btnBack);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, 49));
        }];
        
        [self.btnBack addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.btnBack);
            make.right.mas_equalTo(self.btnBack).mas_offset(-10 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, 49));
        }];
        
        [self addSubview:self.noticeLab];
        [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.btnBack.mas_bottom).mas_offset(11 * UI_H_SCALE);
        }];
        
        [self addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnBack.mas_bottom).mas_equalTo(70 * UI_H_SCALE);
            make.left.equalTo(self).mas_equalTo(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_equalTo(-15 * UI_H_SCALE);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UIView *)btnBack{
    if(!_btnBack){
        _btnBack = [UIView new];
        _btnBack.backgroundColor = UIColor.whiteColor;
    }
    return _btnBack;
}

- (ZYElasticButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [ZYElasticButton new];
        [_leftBtn setImage:[UIImage imageNamed:@"zy_quota_contact_normal"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"zy_quota_contact_selected"] forState:UIControlStateSelected];
        [_leftBtn setTitle:@"父母" forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:FONT(16)];
        [_leftBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        _leftBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0,0);
        __weak __typeof__(self) weakSelf = self;
        [_leftBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.midBtn.selected = NO;
            weakSelf.rightBtn.selected = NO;
            button.selected = YES;
        }];
    }
    return _leftBtn;
}

- (ZYElasticButton *)midBtn{
    if(!_midBtn){
        _midBtn = [ZYElasticButton new];
        [_midBtn setImage:[UIImage imageNamed:@"zy_quota_contact_normal"] forState:UIControlStateNormal];
        [_midBtn setImage:[UIImage imageNamed:@"zy_quota_contact_selected"] forState:UIControlStateSelected];
        [_midBtn setTitle:@"兄弟姐妹" forState:UIControlStateNormal];
        [_midBtn.titleLabel setFont:FONT(16)];
        [_midBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        _midBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        _midBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0,0);
        __weak __typeof__(self) weakSelf = self;
        [_midBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.leftBtn.selected = NO;
            weakSelf.rightBtn.selected = NO;
            button.selected = YES;
        }];
    }
    return _midBtn;
}

- (ZYElasticButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [ZYElasticButton new];
        [_rightBtn setImage:[UIImage imageNamed:@"zy_quota_contact_normal"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"zy_quota_contact_selected"] forState:UIControlStateSelected];
        [_rightBtn setTitle:@"配偶" forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:FONT(16)];
        [_rightBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        _rightBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0,0);
        __weak __typeof__(self) weakSelf = self;
        [_rightBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.leftBtn.selected = NO;
            weakSelf.midBtn.selected = NO;
            button.selected = YES;
        }];
    }
    return _rightBtn;
}

- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.textColor = WORD_COLOR_GRAY;
        _noticeLab.font = FONT(12);
        _noticeLab.text = @"注：请填写真实数据（真实姓名+电话），避免影响授信额度";
        _noticeLab.numberOfLines = 0;
    }
    return _noticeLab;
}

- (ZYElasticButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [ZYElasticButton new];
        [_confirmBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmBtn setFont:FONT(18)];
        [_confirmBtn setShouldRound:YES];
    }
    return _confirmBtn;
}

@end
