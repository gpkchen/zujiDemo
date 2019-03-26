//
//  ZYShareAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYShareAlert.h"
#import "GetMoneyDetails.h"

@interface ZYShareAlert ()

@property (nonatomic , strong) UIView *panelView;
@property (nonatomic , strong) UIImageView *backIV;
@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UIImageView *iv1;
@property (nonatomic , strong) UIImageView *iv2;
@property (nonatomic , strong) UIImageView *iv3;

@property (nonatomic , strong) ZYElasticButton *closeBtn;

@end

@implementation ZYShareAlert

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    [self.panelView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView);
        make.bottom.equalTo(self.panelView);
        make.size.mas_equalTo(self.closeBtn.size);
    }];
    [self.panelView addSubview:self.backIV];
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.panelView);
        make.height.mas_equalTo(self.panelView.height - 42 * UI_H_SCALE);
    }];
    
    [self.panelView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView);
        make.centerY.equalTo(self.panelView.mas_top).mas_offset(30 * UI_H_SCALE);
    }];
    
    [self.panelView addSubview:self.iv1];
    [self.iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panelView).mas_offset(60 * UI_H_SCALE);
        make.centerX.equalTo(self.panelView);
        make.size.mas_equalTo(CGSizeMake(315 * UI_H_SCALE, 113 * UI_H_SCALE));
    }];
    
    [self.panelView addSubview:self.iv2];
    [self.iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv1.mas_bottom).mas_offset(15 * UI_H_SCALE);
        make.centerX.equalTo(self.panelView);
        make.size.mas_equalTo(CGSizeMake(315 * UI_H_SCALE, 113 * UI_H_SCALE));
    }];
    
    [self.panelView addSubview:self.iv3];
    [self.iv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv2.mas_bottom).mas_offset(15 * UI_H_SCALE);
        make.centerX.equalTo(self.panelView);
        make.size.mas_equalTo(CGSizeMake(315 * UI_H_SCALE, 113 * UI_H_SCALE));
    }];
}

#pragma mark - public
- (void)showWithModelWith:(_m_GetMoneyDetails_benefit *)model;{
    self.backIV.image = [UIImage imageNamed:@"zy_share_alert_back_large"];
    self.titleLab.text = model.title;
    
    NSUInteger num = model.benefitDetails.count;
    if (1 == model.benefitDetails.count) {
        [self.iv1 loadImage:model.benefitDetails[0]];
        [self.iv2 loadImage:nil];
        [self.iv3 loadImage:nil];
    }
    if (2 == model.benefitDetails.count) {
        [self.iv1 loadImage:model.benefitDetails[0]];
        [self.iv2 loadImage:model.benefitDetails[1]];
        [self.iv3 loadImage:nil];
    }
    if (3 == model.benefitDetails.count) {
        [self.iv1 loadImage:model.benefitDetails[0]];
        [self.iv2 loadImage:model.benefitDetails[1]];
        [self.iv3 loadImage:model.benefitDetails[2]];
    }
    
    if (3 == num) {
        [self.iv2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iv1.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.centerX.equalTo(self.panelView);
            make.size.mas_equalTo(CGSizeMake(315 * UI_H_SCALE, 113 * UI_H_SCALE));
        }];
        [self.iv3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iv2.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.centerX.equalTo(self.panelView);
            make.size.mas_equalTo(CGSizeMake(315 * UI_H_SCALE, 113 * UI_H_SCALE));
        }];
    } else if (2 == num) {
        [self.iv2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iv1.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.centerX.equalTo(self.panelView);
            make.size.mas_equalTo(CGSizeMake(315 * UI_H_SCALE, 113 * UI_H_SCALE));
        }];
        [self.iv3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iv2.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.centerX.equalTo(self.panelView);
            make.size.mas_equalTo(CGSizeZero);
        }];
    } else if (1== num){
        [self.iv2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iv1.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.centerX.equalTo(self.panelView);
            make.size.mas_equalTo(CGSizeZero);
        }];
        [self.iv3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iv2.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.centerX.equalTo(self.panelView);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    
    self.panelView.height = 124 * UI_H_SCALE + num * (113 * UI_H_SCALE + 15 * UI_H_SCALE) - 15 * UI_H_SCALE;
    [self.backIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.panelView.height - 42 * UI_H_SCALE);
    }];
    
    [self showWithPanelView:self.panelView];
}

#pragma mark - getter
- (UIView *)panelView{
    if(!_panelView){
        _panelView = [UIView new];
        _panelView.backgroundColor = [UIColor clearColor];
        _panelView.size = CGSizeMake(345 * UI_H_SCALE, 362 * UI_H_SCALE);
    }
    return _panelView;
}

- (UIImageView *)backIV{
    if(!_backIV){
        _backIV = [UIImageView new];
        _backIV.backgroundColor = [UIColor clearColor];
        _backIV.clipsToBounds = YES;
    }
    return _backIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = FONT(20);
    }
    return _titleLab;
}

- (UIImageView *)iv1{
    if(!_iv1){
        _iv1 = [UIImageView new];
        _iv1.contentMode = UIViewContentModeScaleAspectFill;
        _iv1.backgroundColor = [UIColor clearColor];
        _iv1.clipsToBounds = YES;
    }
    return _iv1;
}

- (UIImageView *)iv2{
    if(!_iv2){
        _iv2 = [UIImageView new];
        _iv2.contentMode = UIViewContentModeScaleAspectFill;
        _iv2.clipsToBounds = YES;
        _iv2.backgroundColor = [UIColor clearColor];
    }
    return _iv2;
}

- (UIImageView *)iv3{
    if(!_iv3){
        _iv3 = [UIImageView new];
        _iv3.contentMode = UIViewContentModeScaleAspectFill;
        _iv3.backgroundColor = [UIColor clearColor];
        _iv3.clipsToBounds = YES;
    }
    return _iv3;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = [UIColor clearColor];
        UIImage *img = [UIImage imageNamed:@"zy_share_alert_close_btn"];
        [_closeBtn setImage:img forState:UIControlStateNormal];
        [_closeBtn setImage:img forState:UIControlStateHighlighted];
        _closeBtn.size = img.size;
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
    }
    return _closeBtn;
}

@end
