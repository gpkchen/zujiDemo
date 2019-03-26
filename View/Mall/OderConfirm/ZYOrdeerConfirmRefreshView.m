//
//  ZYOrdeerConfirmRefreshView.m
//  Apollo
//
//  Created by zhxc on 2018/12/14.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYOrdeerConfirmRefreshView.h"

@interface ZYOrdeerConfirmRefreshView()

@property (nonatomic , strong) UIImageView *iv;
@property (nonatomic , strong) UILabel *lab;

@end

@implementation ZYOrdeerConfirmRefreshView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [self addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT + 116 * UI_H_SCALE);
        }];
        
        [self addSubview:self.lab];
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.iv.mas_bottom).mas_offset(30.5 * UI_H_SCALE);
        }];
        
        [self addSubview:self.refreshBtn];
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.iv.mas_bottom).mas_offset(159 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(60 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)iv{
    if(!_iv){
        _iv = [UIImageView new];
        _iv.image = [UIImage imageNamed:@"zy_error_waiting"];
    }
    return _iv;
}

- (UILabel *)lab{
    if(!_lab){
        _lab = [UILabel new];
        _lab.font = FONT(15);
        _lab.textColor = WORD_COLOR_BLACK;
        _lab.text = @"支付宝处理中，请勿离开当前页面";
    }
    return _lab;
}

- (ZYElasticButton *)refreshBtn{
    if(!_refreshBtn){
        _refreshBtn = [ZYElasticButton new];
        _refreshBtn.backgroundColor = UIColor.whiteColor;
        _refreshBtn.cornerRadius = 2;
        _refreshBtn.borderWidth = 1;
        _refreshBtn.borderColor = MAIN_COLOR_GREEN;
        _refreshBtn.font = FONT(15);
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _refreshBtn;
}

@end
