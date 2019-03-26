//
//  ZYReturnNoticeView.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnNoticeView.h"

@interface ZYReturnNoticeView()

@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) UILabel *lab;

@end

@implementation ZYReturnNoticeView

- (instancetype)init{
    if(self = [super init]){
        self.userInteractionEnabled = YES;
        self.backgroundColor = UIColor.clearColor;
        self.clipsToBounds = YES;
        self.image = [UIImage imageNamed:@"zy_order_return_notice_back"];
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.bottom.equalTo(self).mas_offset(-10 * UI_H_SCALE);
            make.width.mas_equalTo(52 * UI_H_SCALE);
        }];
        
        [self addSubview:self.lab];
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self).mas_offset(-5 * UI_H_SCALE);
            make.right.equalTo(self.closeBtn.mas_left);
        }];
    }
    return self;
}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = self.endFrame;
    }];
    _isShowed = YES;
}

- (void)dismiss{
    if(self.superview){
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = self.beginFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - setter
- (void)setBeginFrame:(CGRect)beginFrame{
    _beginFrame = beginFrame;
    self.frame = _beginFrame;
}

#pragma mark - getter
- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = UIColor.clearColor;
        [_closeBtn setImage:[UIImage imageNamed:@"zy_order_return_notice_close"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_order_return_notice_close"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
    }
    return _closeBtn;
}

- (UILabel *)lab{
    if(!_lab){
        _lab = [UILabel new];
        _lab.textColor = UIColor.whiteColor;
        _lab.font = FONT(14);
        _lab.numberOfLines = 0;
        _lab.text = @"寄出后请及时填写运单号，否则可能会导致逾期噢。";
    }
    return _lab;
}

@end
