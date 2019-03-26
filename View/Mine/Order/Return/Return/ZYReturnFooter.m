//
//  ZYReturnFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnFooter.h"

@interface ZYReturnFooter()

@property (nonatomic , strong) UILabel *lab;

@end

@implementation ZYReturnFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCREEN_WIDTH, self.lab.height + 40 * UI_H_SCALE);
        
        [self addSubview:self.lab];
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_equalTo(20 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title{
    _title = title;
    self.lab.text = title;
}

#pragma mark - getter
- (UILabel *)lab{
    if(!_lab){
        _lab = [UILabel new];
        _lab.textColor = HexRGB(0x4a4a4a);
        _lab.font = FONT(14);
        _lab.numberOfLines = 0;
        _lab.text = @"你所在的城市暂无线下归还的门店噢；\n请选择邮寄归还。";
        _lab.textAlignment = NSTextAlignmentCenter;
        [_lab sizeToFit];
    }
    return _lab;
}

@end
