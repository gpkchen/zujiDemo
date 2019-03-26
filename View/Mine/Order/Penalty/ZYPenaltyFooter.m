//
//  ZYPenaltyFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPenaltyFooter.h"

@interface ZYPenaltyFooter ()

@property (nonatomic , strong) UILabel *noticeLab;

@end

@implementation ZYPenaltyFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.noticeLab];
        [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.left.top.equalTo(self).mas_offset(15 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.textColor = WORD_COLOR_GRAY;
        _noticeLab.font = FONT(12);
        _noticeLab.numberOfLines = 0;
        _noticeLab.lineBreakMode = NSLineBreakByWordWrapping;
        _noticeLab.text = @"如有疑问请联系热线400-015-6868，或在首页在线联系客服。";
    }
    return _noticeLab;
}

@end
