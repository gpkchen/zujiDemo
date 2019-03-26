//
//  ZYCreateQuotaFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCreateQuotaFooter.h"

@implementation ZYCreateQuotaFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.createBtn];
        [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self).mas_offset(130 * UI_H_SCALE);
            make.height.mas_equalTo(49 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYElasticButton *)createBtn{
    if(!_createBtn){
        _createBtn = [ZYElasticButton new];
        _createBtn.shouldRound = YES;
        _createBtn.font = FONT(18);
        _createBtn.enabled = NO;
        [_createBtn setTitle:@"获取免押额度" forState:UIControlStateNormal];
        [_createBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_createBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        [_createBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_createBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_createBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
    }
    return _createBtn;
}

@end
