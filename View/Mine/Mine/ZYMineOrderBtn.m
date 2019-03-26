//
//  ZYMineOrderBtn.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMineOrderBtn.h"

@interface ZYMineOrderBtn()

@property (nonatomic , strong) UIImageView *iv;
@property (nonatomic , strong) UILabel *lab;
@property (nonatomic , strong) UILabel *numLab;

@end

@implementation ZYMineOrderBtn

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.lab];
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.iv.mas_bottom).mas_offset(13.5);
        }];
        
        [self addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iv.mas_right);
            make.centerY.equalTo(self.iv.mas_top);
            make.size.mas_equalTo(CGSizeMake(14 * UI_H_SCALE, 14 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    self.iv.image = icon;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.lab.text = title;
}

- (void)setNum:(int)num{
    _num = num;
    if(num == 0){
        self.numLab.hidden = YES;
        return;
    }
    self.numLab.hidden = NO;
    if(num <= 99){
        self.numLab.text = [NSString stringWithFormat:@"%d",num];
    }else{
        self.numLab.text = @"99+";
    }
    if(num < 10){
        [self.numLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14 * UI_H_SCALE, 14 * UI_H_SCALE));
        }];
    }else{
        [self.numLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24 * UI_H_SCALE, 14 * UI_H_SCALE));
        }];
    }
}

#pragma mark - getter
- (UIImageView *)iv{
    if(!_iv){
        _iv = [UIImageView new];
    }
    return _iv;
}

- (UILabel *)lab{
    if(!_lab){
        _lab = [UILabel new];
        _lab.textColor = HexRGB(0x999999);
        _lab.font = FONT(12);
    }
    return _lab;
}

- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.textColor = UIColor.whiteColor;
        _numLab.font = FONT(10);
        _numLab.backgroundColor = HexRGB(0xFF5E5E);
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.clipsToBounds = YES;
        _numLab.hidden = YES;
        _numLab.cornerRadius = 7 * UI_H_SCALE;
    }
    return _numLab;
}

@end
