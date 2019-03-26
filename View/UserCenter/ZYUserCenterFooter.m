//
//  ZYUserCenterFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUserCenterFooter.h"

@interface ZYUserCenterFooter()

@property (nonatomic , strong) UIImageView *emptyIV;

@end

@implementation ZYUserCenterFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.emptyIV];
        [self.emptyIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(44 * UI_H_SCALE);
        }];
        
        [self addSubview:self.publishBtn];
        [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.emptyIV.mas_bottom).mas_offset(20 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)emptyIV{
    if(!_emptyIV){
        _emptyIV = [UIImageView new];
        _emptyIV.image = [UIImage imageNamed:@"zy_usercenter_empty_img"];
    }
    return _emptyIV;
}

- (ZYElasticButton *)publishBtn{
    if(!_publishBtn){
        _publishBtn = [ZYElasticButton new];
        [_publishBtn setTitle:@"去发布" forState:UIControlStateNormal];
        _publishBtn.font = FONT(14);
        _publishBtn.backgroundColor = UIColor.whiteColor;
        [_publishBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_publishBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _publishBtn.shouldRound = YES;
        _publishBtn.borderColor = MAIN_COLOR_GREEN;
        _publishBtn.borderWidth = 1;
    }
    return _publishBtn;
}

@end
