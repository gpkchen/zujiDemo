//
//  ZYReturnMenu.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnMenu.h"

@interface ZYReturnMenu()

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) UILabel *noticeLab;
@property (nonatomic , strong) ZYElasticButton *storeBtn;
@property (nonatomic , strong) ZYElasticButton *mailBtn;

@end

@implementation ZYReturnMenu

- (instancetype)init{
    if(self = [super init]){
        [self.panel addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.panel);
            make.height.mas_equalTo(56 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self.titleLab);
            make.width.mas_equalTo(self.closeBtn.width + 30 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.noticeLab];
        [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panel);
            make.centerY.equalTo(self.titleLab.mas_bottom).mas_offset(38 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.storeBtn];
        [self.storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panel).mas_equalTo(15 * UI_H_SCALE);
            make.bottom.equalTo(self.panel).mas_offset(-15 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(165 * UI_H_SCALE, 50 * UI_H_SCALE));
        }];
        
        [self.panel addSubview:self.mailBtn];
        [self.mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.panel).mas_equalTo(-15 * UI_H_SCALE);
            make.bottom.equalTo(self.panel).mas_offset(-15 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(165 * UI_H_SCALE, 50 * UI_H_SCALE));
        }];
    }
    return self;
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
        _panel.size = CGSizeMake(SCREEN_WIDTH, 208 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
        _panel.backgroundColor = VIEW_COLOR;
    }
    return _panel;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = FONT(20);
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.text = @"请选择归还方式";
        _titleLab.backgroundColor = UIColor.whiteColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = UIColor.whiteColor;
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        [_closeBtn sizeToFit];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
        }];
    }
    return _closeBtn;
}

- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.font = FONT(15);
        _noticeLab.textColor = WORD_COLOR_BLACK;
        _noticeLab.text = @"选择“邮寄归还”所产生的运费需要自理噢\n请勿选择到付";
        _noticeLab.textAlignment = NSTextAlignmentCenter;
        _noticeLab.numberOfLines = 0;
    }
    return _noticeLab;
}

- (ZYElasticButton *)storeBtn{
    if(!_storeBtn){
        _storeBtn = [ZYElasticButton new];
        _storeBtn.backgroundColor = VIEW_COLOR;
        _storeBtn.font = FONT(18);
        [_storeBtn setTitle:@"到店归还" forState:UIControlStateNormal];
        [_storeBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_storeBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _storeBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _storeBtn.borderWidth = 1;
        
        __weak __typeof__(self) weakSelf = self;
        [_storeBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.buttonAction ? : weakSelf.buttonAction();
            [weakSelf dismiss:nil];
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYReturnVC?orderId=%@&addressUseScene=%@",[weakSelf.orderId URLEncode],@"1"]];
        }];
    }
    return _storeBtn;
}

- (ZYElasticButton *)mailBtn{
    if(!_mailBtn){
        _mailBtn = [ZYElasticButton new];
        _mailBtn.font = FONT(18);
        [_mailBtn setTitle:@"邮寄归还" forState:UIControlStateNormal];
        [_mailBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_mailBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_mailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_mailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_mailBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.buttonAction ? : weakSelf.buttonAction();
            [weakSelf dismiss:nil];
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYReturnVC?orderId=%@&addressUseScene=%@",[weakSelf.orderId URLEncode],@"2"]];
        }];
    }
    return _mailBtn;
}

@end
