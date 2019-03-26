//
//  ZYItemDetailDepositAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailDepositAlert.h"

static NSString * const kZYItemDetailDepositAlertCanceledKey = @"kZYItemDetailDepositAlertCanceledKey";

@interface ZYItemDetailDepositAlert ()

@property (nonatomic , strong) UIView *panelView;
@property (nonatomic , strong) UIImageView *backIV;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) ZYElasticButton *cancelBtn;
@property (nonatomic , strong) ZYElasticButton *applyBtn;

@end

@implementation ZYItemDetailDepositAlert

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    [self.panelView addSubview:self.backIV];
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.panelView);
        make.height.mas_equalTo(60 * UI_H_SCALE);
    }];
    
    [self.panelView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.panelView);
        make.bottom.equalTo(self.panelView).mas_offset(-59 * UI_H_SCALE);
        make.height.mas_equalTo(1);
    }];
    
    [self.panelView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.panelView);
        make.right.equalTo(self.panelView.mas_centerX);
        make.top.equalTo(self.line.mas_bottom);
    }];
    
    [self.panelView addSubview:self.applyBtn];
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.panelView);
        make.left.equalTo(self.panelView.mas_centerX);
        make.top.equalTo(self.line.mas_bottom);
    }];
    
    [self.panelView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView);
        make.centerY.equalTo(self.panelView.mas_top).mas_offset(95 * UI_H_SCALE);
    }];
}

#pragma mark - public
- (void)show{
    [super showWithPanelView:self.panelView];
}

#pragma mark - getter
- (UIView *)panelView{
    if(!_panelView){
        _panelView = [UIView new];
        _panelView.backgroundColor = [UIColor whiteColor];
        _panelView.size = CGSizeMake(315 * UI_H_SCALE, 192 * UI_H_SCALE);
        _panelView.cornerRadius = 5;
        _panelView.clipsToBounds = YES;
    }
    return _panelView;
}

- (UIImageView *)backIV{
    if(!_backIV){
        _backIV = [UIImageView new];
        _backIV.contentMode = UIViewContentModeScaleAspectFill;
        _backIV.image = [UIImage imageNamed:@"zy_item_detail_deposit_alert_back"];
    }
    return _backIV;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (ZYElasticButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [ZYElasticButton new];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.font = FONT(16);
        [_cancelBtn setTitleColor:HexRGB(0xABADB3) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HexRGB(0xABADB3) forState:UIControlStateHighlighted];
        [_cancelBtn setTitle:@"不想申请" forState:UIControlStateNormal];
        
        __weak __typeof__(self) weakSelf = self;
        [_cancelBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
            !weakSelf.applyBlock ? : weakSelf.applyBlock(YES);
            [NSUserDefaults writeWithObject:kZYItemDetailDepositAlertCanceledKey forKey:kZYItemDetailDepositAlertCanceledKey];
        }];
    }
    return _cancelBtn;
}

- (ZYElasticButton *)applyBtn{
    if(!_applyBtn){
        _applyBtn = [ZYElasticButton new];
        _applyBtn.backgroundColor = [UIColor whiteColor];
        _applyBtn.font = FONT(16);
        [_applyBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_applyBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_applyBtn setTitle:@"去申请" forState:UIControlStateNormal];
        
        __weak __typeof__(self) weakSelf = self;
        [_applyBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
            !weakSelf.applyBlock ? : weakSelf.applyBlock(NO);
        }];
    }
    return _applyBtn;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.font = FONT(16);
        _contentLab.textColor = WORD_COLOR_BLACK;
        _contentLab.text = @"申请通过后可以享受免押金租机";
    }
    return _contentLab;
}

- (BOOL)shouldShow{
    NSString *key = [NSUserDefaults readObjectWithKey:kZYItemDetailDepositAlertCanceledKey];
    return ![kZYItemDetailDepositAlertCanceledKey isEqualToString:key];
}

@end
