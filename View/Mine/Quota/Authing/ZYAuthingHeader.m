//
//  ZYAuthingHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAuthingHeader.h"

@interface ZYAuthingHeader()

@property (nonatomic , strong) UIImageView *authingIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *detailLab;

@end

@implementation ZYAuthingHeader

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.authingIV];
        [self.authingIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(39 * UI_H_SCALE);
        }];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_top).mas_offset(114 * UI_H_SCALE);
        }];
        
        [self addSubview:self.detailLab];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(135 * UI_H_SCALE);
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self addSubview:self.wanderingBtn];
        [self.wanderingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).mas_offset(-28 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(120 * UI_H_SCALE, 40 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)authingIV{
    if(!_authingIV){
        _authingIV = [UIImageView new];
        _authingIV.image = [UIImage imageNamed:@"zy_quota_authing_logo"];
    }
    return _authingIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(16);
        _titleLab.text = @"提交成功，正在为您评估中…";
    }
    return _titleLab;
}

- (UILabel *)detailLab{
    if(!_detailLab){
        _detailLab = [UILabel new];
        _detailLab.textColor = WORD_COLOR_GRAY_AB;
        _detailLab.font = FONT(14);
        _detailLab.text = @"评估结果将在24小时内通过短信及App消息推送给你，\n请注意查收哦～";
        _detailLab.textAlignment = NSTextAlignmentCenter;
        _detailLab.numberOfLines = 0;
        _detailLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailLab;
}

- (ZYElasticButton *)wanderingBtn{
    if(!_wanderingBtn){
        _wanderingBtn = [ZYElasticButton new];
        _wanderingBtn.shouldRound = YES;
        _wanderingBtn.font = FONT(14);
        [_wanderingBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
        [_wanderingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_wanderingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        [_wanderingBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_wanderingBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _wanderingBtn;
}

@end
