//
//  ZYShareHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/30.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYShareHeader.h"

@interface ZYShareHeader ()

@property (nonatomic , strong) UIImageView *upIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIView *vLine;

@property (nonatomic , strong) UILabel *inviteNumTitleLab;
@property (nonatomic , strong) UILabel *inviteAmountTitleLab;

@end

@implementation ZYShareHeader

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.upIV];
    [self.upIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(FRINGE_TOP_EXTRA_HEIGHT + 180 * UI_H_SCALE);
    }];
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_top).mas_offset(STATUSBAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT) / 2.0);
    }];
    
    [self addSubview:self.vLine];
    [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.upIV).mas_offset(-35 * UI_H_SCALE);
        make.height.mas_equalTo(60 * UI_H_SCALE);
        make.width.mas_equalTo(LINE_HEIGHT);
    }];
    
    [self addSubview:self.inviteNumLab];
    [self.inviteNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 4.0);
        make.centerY.equalTo(self.upIV.mas_bottom).mas_offset(-71.5 * UI_H_SCALE);
    }];
    
    [self addSubview:self.inviteAmountLab];
    [self.inviteAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / 4.0 * 3);
        make.centerY.equalTo(self.upIV.mas_bottom).mas_offset(-71.5 * UI_H_SCALE);
    }];
    
    [self addSubview:self.inviteNumTitleLab];
    [self.inviteNumTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inviteNumLab);
        make.centerY.equalTo(self.upIV.mas_bottom).mas_offset(-45.5 * UI_H_SCALE);
    }];
    
    [self addSubview:self.inviteAmountTitleLab];
    [self.inviteAmountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inviteAmountLab);
        make.centerY.equalTo(self.upIV.mas_bottom).mas_offset(-45.5 * UI_H_SCALE);
    }];
    
    [self addSubview:self.jumpLabel];
    [self.jumpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.upIV.mas_bottom);
        make.height.mas_equalTo(55 * UI_H_SCALE);
    }];
}

#pragma mark - getter
- (UIImageView *)upIV{
    if(!_upIV){
        _upIV = [UIImageView new];
        _upIV.contentMode = UIViewContentModeScaleAspectFill;
        _upIV.image = [UIImage imageNamed:@"zy_share_up_back"];
        _upIV.clipsToBounds = YES;
    }
    return _upIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = FONT(17);
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"赚佣金";
    }
    return _titleLab;
}

- (UIView *)vLine{
    if(!_vLine){
        _vLine = [UIView new];
        _vLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    }
    return _vLine;
}

- (UILabel *)inviteNumLab{
    if(!_inviteNumLab){
        _inviteNumLab = [UILabel new];
        _inviteNumLab.textColor = [UIColor whiteColor];
        _inviteNumLab.font = BOLD_FONT(24);
    }
    return _inviteNumLab;
}

- (UILabel *)inviteAmountLab{
    if(!_inviteAmountLab){
        _inviteAmountLab = [UILabel new];
        _inviteAmountLab.textColor = [UIColor whiteColor];
        _inviteAmountLab.font = BOLD_FONT(24);
    }
    return _inviteAmountLab;
}

- (UILabel *)inviteNumTitleLab{
    if(!_inviteNumTitleLab){
        _inviteNumTitleLab = [UILabel new];
        _inviteNumTitleLab.textColor = [UIColor whiteColor];
        _inviteNumTitleLab.font = FONT(12);
        _inviteNumTitleLab.text = @"已邀请好友(人)";
    }
    return _inviteNumTitleLab;
}

- (UILabel *)inviteAmountTitleLab{
    if(!_inviteAmountTitleLab){
        _inviteAmountTitleLab = [UILabel new];
        _inviteAmountTitleLab.textColor = [UIColor whiteColor];
        _inviteAmountTitleLab.font = FONT(12);
        _inviteAmountTitleLab.text = @"已得现金优惠券(元)";
    }
    return _inviteAmountTitleLab;
}

- (ZYJumpLabel *)jumpLabel{
    if(!_jumpLabel){
        _jumpLabel = [ZYJumpLabel new];
        _jumpLabel.backgroundColor = [UIColor whiteColor];
        _jumpLabel.isHaveHeadImg = YES;
        _jumpLabel.labelFont = FONT(14);
        _jumpLabel.color = WORD_COLOR_BLACK;
        _jumpLabel.headImg = [UIImage imageNamed:@"zy_share_notice"];
        _jumpLabel.headImgFrame = CGRectMake(15 * UI_H_SCALE,
                                             (55 * UI_H_SCALE - _jumpLabel.headImg.size.height) / 2,
                                             _jumpLabel.headImg.size.width,
                                             _jumpLabel.headImg.size.height);
    }
    return _jumpLabel;
}

@end
