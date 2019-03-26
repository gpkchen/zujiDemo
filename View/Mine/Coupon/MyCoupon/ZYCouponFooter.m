//
//  ZYCouponFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/27.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYCouponFooter.h"

@interface ZYCouponFooter()

@property (nonatomic , strong) UIView *line;

@end

@implementation ZYCouponFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCREEN_WIDTH, self.historyLab.height + 30 * UI_H_SCALE);
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(1, 12 * UI_H_SCALE));
        }];
        
        [self addSubview:self.noMoreLab];
        [self.noMoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.line);
            make.right.equalTo(self.line.mas_left).mas_offset(-4 * UI_H_SCALE);
        }];
        
        [self addSubview:self.historyLab];
        [self.historyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_right).mas_offset(4 * UI_H_SCALE);
            make.centerY.equalTo(self.line);
            make.size.mas_equalTo(CGSizeMake(self.historyLab.width, 30 * UI_H_SCALE + self.historyLab.height));
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)noMoreLab{
    if(!_noMoreLab){
        _noMoreLab = [UILabel new];
        _noMoreLab.textColor = HexRGB(0xa7a7a7);
        _noMoreLab.font = FONT(14);
        _noMoreLab.text = @"没有更多优惠券";
    }
    return _noMoreLab;
}

- (UILabel *)historyLab{
    if(!_historyLab){
        _historyLab = [UILabel new];
        _historyLab.textColor = BTN_COLOR_NORMAL_GREEN;
        _historyLab.font = FONT(14);
        _historyLab.text = @"查看历史失效券";
        _historyLab.userInteractionEnabled = YES;
        [_historyLab sizeToFit];
    }
    return _historyLab;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = HexRGB(0xd8d8d8);
    }
    return _line;
}

@end
