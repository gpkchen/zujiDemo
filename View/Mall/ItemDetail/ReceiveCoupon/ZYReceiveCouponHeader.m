//
//  ZYReceiveCouponHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/28.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReceiveCouponHeader.h"

@implementation ZYReceiveCouponHeader

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = HexRGB(0xF7FAF8);
        
        [self addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_bottom).mas_offset(-18 * UI_H_SCALE);
        }];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_bottom).mas_offset(-18 * UI_H_SCALE);
            make.right.lessThanOrEqualTo(self.numLab.mas_left);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = SEMIBOLD_FONT(16);
    }
    return _titleLab;
}

- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.textColor = WORD_COLOR_BLACK;
        _numLab.font = LIGHT_FONT(14);
    }
    return _numLab;
}

@end
