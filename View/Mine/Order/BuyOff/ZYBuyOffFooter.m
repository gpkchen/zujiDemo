//
//  ZYBuyOffFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBuyOffFooter.h"

@interface ZYBuyOffFooter ()

@property (nonatomic , strong) UILabel *noticeLab;

@end

@implementation ZYBuyOffFooter

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

#pragma mark - setter
- (void)setType:(ZYBuyOffPayType)type{
    _type = type;
    if(type == ZYBuyOffPayTypePay){
        self.noticeLab.text = @"确认购买后，您将永久获得该商品，押金将作为支付款项永久扣除，不再返还。";
    }else{
        self.noticeLab.text = @"确认购买后，您将永久获得该商品，押金将作为支付款项永久扣除。(可退还部分的金额将在七个工作日内返还到您的付款账号，请注意查收，如有疑问请联系客服。)";
    }
}

#pragma mark - getter
- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.textColor = WORD_COLOR_GRAY;
        _noticeLab.font = FONT(12);
        _noticeLab.numberOfLines = 0;
        _noticeLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _noticeLab;
}

@end
