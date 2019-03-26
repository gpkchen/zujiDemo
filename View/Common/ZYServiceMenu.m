//
//  ZYServiceMenu.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/8.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYServiceMenu.h"

@interface ZYServiceMenu()

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) ZYElasticButton *qustionBtn;
@property (nonatomic , strong) ZYElasticButton *serviceBtn;
@property (nonatomic , strong) ZYElasticButton *callBtn;
@property (nonatomic , strong) ZYElasticButton *cancelBtn;

@property (nonatomic , strong) UIView *line1;
@property (nonatomic , strong) UIView *line2;

@end

@implementation ZYServiceMenu

- (instancetype)init{
    if(self = [super init]){
        [self.panel addSubview:self.qustionBtn];
        [self.qustionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.panel);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.serviceBtn];
        [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.top.equalTo(self.qustionBtn.mas_bottom);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.callBtn];
        [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.top.equalTo(self.serviceBtn.mas_bottom);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.top.equalTo(self.callBtn.mas_bottom);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.line1];
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.top.equalTo(self.qustionBtn.mas_bottom);
        }];
        
        [self.panel addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.top.equalTo(self.serviceBtn.mas_bottom);
        }];
    }
    return self;
}

- (void)show{
    self.panelView = self.panel;
    [super show];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.backgroundColor = UIColor.whiteColor;
        _panel.size = CGSizeMake(SCREEN_WIDTH, 200 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }
    return _panel;
}

- (ZYElasticButton *)qustionBtn{
    if(!_qustionBtn){
        _qustionBtn = [ZYElasticButton new];
        _qustionBtn.backgroundColor = UIColor.whiteColor;
        _qustionBtn.shouldAnimate = NO;
        _qustionBtn.font = FONT(15);
        [_qustionBtn setTitle:@"常见问题" forState:UIControlStateNormal];
        [_qustionBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        [_qustionBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_qustionBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@&swipeToBack=0&alwaysBounceVertical=0&alwaysBounceHorizontal=0",
                                              [[ZYH5Utils formatUrl:ZYH5TypeHelp param:nil] URLEncode]]];
        }];
    }
    return _qustionBtn;
}

- (ZYElasticButton *)serviceBtn{
    if(!_serviceBtn){
        _serviceBtn = [ZYElasticButton new];
        _serviceBtn.backgroundColor = UIColor.whiteColor;
        _serviceBtn.shouldAnimate = NO;
        _serviceBtn.font = FONT(15);
        [_serviceBtn setTitle:@"在线客服" forState:UIControlStateNormal];
        [_serviceBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        [_serviceBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_serviceBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
            [[ZYRouter router] goWithoutHead:@"service"];
        }];
    }
    return _serviceBtn;
}

- (ZYElasticButton *)callBtn{
    if(!_callBtn){
        _callBtn = [ZYElasticButton new];
        _callBtn.backgroundColor = UIColor.whiteColor;
        _callBtn.shouldAnimate = NO;
        _callBtn.font = FONT(15);
        [_callBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [_callBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        [_callBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_callBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"call?number=%@",weakSelf.phone]];
        }];
    }
    return _callBtn;
}

- (ZYElasticButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [ZYElasticButton new];
        _cancelBtn.backgroundColor = HexRGB(0xe3e6e4);
        _cancelBtn.shouldAnimate = NO;
        _cancelBtn.font = FONT(15);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_cancelBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
        }];
    }
    return _cancelBtn;
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

@end
