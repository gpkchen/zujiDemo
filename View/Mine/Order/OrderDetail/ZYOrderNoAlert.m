//
//  ZYOrderNoAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/19.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYOrderNoAlert.h"

@interface ZYOrderNoAlert()

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) ZYElasticButton *sendBtn;
@property (nonatomic , strong) ZYElasticButton *cancelBtn;

@end

@implementation ZYOrderNoAlert

- (instancetype)init{
    if(self = [super init]){
        [self.panel addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.top.equalTo(self.panel).mas_offset(50 * UI_H_SCALE);
            make.bottom.equalTo(self.panel).mas_offset(-60 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.panel);
            make.size.mas_equalTo(CGSizeMake(30 + 30 * UI_H_SCALE, 50 * UI_H_SCALE));
        }];
        
        [self.panel addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panel).mas_offset(30 * UI_H_SCALE);
            make.top.equalTo(self.contentLab.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self.panel addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.panel).mas_offset(-30 * UI_H_SCALE);
            make.top.equalTo(self.contentLab.mas_bottom).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - public
- (void)show{
    [super showWithPanelView:self.panel];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.size = CGSizeMake(280 * UI_H_SCALE, 186 * UI_H_SCALE);
        _panel.backgroundColor = UIColor.whiteColor;
        _panel.cornerRadius = 8;
    }
    return _panel;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.backgroundColor = VIEW_COLOR;
        _contentLab.textColor = WORD_COLOR_BLACK;
        _contentLab.font = FONT(15);
        _contentLab.numberOfLines = 0;
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"是否要将此订单号发送给\n客服小姐姐？";
    }
    return _contentLab;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = UIColor.clearColor;
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
    }
    return _closeBtn;
}

- (ZYElasticButton *)sendBtn{
    if(!_sendBtn){
        _sendBtn = [ZYElasticButton new];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        _sendBtn.font = FONT(15);
        _sendBtn.shouldRound = YES;
        [_sendBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_sendBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
            [[ZYRouter router] goWithoutHead:@"service"];
        }];
    }
    return _sendBtn;
}

- (ZYElasticButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [ZYElasticButton new];
        [_cancelBtn setTitle:@"不了" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _cancelBtn.font = FONT(15);
        _cancelBtn.shouldRound = YES;
        _cancelBtn.backgroundColor = UIColor.whiteColor;
        _cancelBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _cancelBtn.borderWidth = 1;
        
        __weak __typeof__(self) weakSelf = self;
        [_cancelBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
    }
    return _cancelBtn;
}

@end
