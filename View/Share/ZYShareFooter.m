//
//  ZYShareFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/30.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYShareFooter.h"

@implementation ZYShareFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.taskBtn];
        [self.taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.height.mas_equalTo(44 * UI_H_SCALE);
            make.top.equalTo(self).mas_offset(26 * UI_H_SCALE);
            make.width.mas_equalTo((SCREEN_WIDTH - 40 * UI_H_SCALE) / 2.0);
        }];
        
        [self addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.height.mas_equalTo(44 * UI_H_SCALE);
            make.top.equalTo(self).mas_offset(26 * UI_H_SCALE);
            make.width.mas_equalTo(SCREEN_WIDTH - 30 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYElasticButton *)taskBtn{
    if(!_taskBtn){
        _taskBtn = [ZYElasticButton new];
        _taskBtn.shouldRound = YES;
        _taskBtn.hidden = YES;
        _taskBtn.backgroundColor = [UIColor whiteColor];
        _taskBtn.font = FONT(14);
        [_taskBtn setTitle:@"做任务赚现金" forState:UIControlStateNormal];
        [_taskBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
    }
    return _taskBtn;
}

- (ZYElasticButton *)shareBtn{
    if(!_shareBtn){
        _shareBtn = [ZYElasticButton new];
        _shareBtn.shouldRound = YES;
        _shareBtn.font = FONT(14);
        [_shareBtn setTitle:@"邀请好友赚现金" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_shareBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _shareBtn;
}

@end
