//
//  ZYExchangeCouponResultView.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYExchangeCouponResultView.h"

@interface ZYExchangeCouponResultView()

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;

@end

@implementation ZYExchangeCouponResultView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
        }];
        
        [self.header addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.header).mas_offset(UIEdgeInsetsMake(10 * UI_H_SCALE, 0, 10 * UI_H_SCALE, 0));
        }];
        
        [self.backView addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.top.equalTo(self.backView).mas_offset(30 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(19.5 * UI_H_SCALE);
            make.centerX.equalTo(self.backView);
        }];
        
        [self.backView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(45 * UI_H_SCALE);
            make.centerX.equalTo(self.backView);
        }];
        
        [self.backView addSubview:self.orderBtn];
        [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.bottom.equalTo(self.backView).mas_offset(-30 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(240 * UI_H_SCALE, 44 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
    }
    return _tableView;
}

- (UIView *)header{
    if(!_header){
        _header = [UIView new];
        _header.size = CGSizeMake(SCREEN_WIDTH, 224 * UI_H_SCALE + 20 * UI_H_SCALE);
        _header.backgroundColor = UIColor.whiteColor;
    }
    return _header;
}

- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = UIColor.whiteColor;
    }
    return _backView;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"zy_mall_pay_success_icon"];
    }
    return _iconIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(18);
        _titleLab.text = @"恭喜你，兑换成功";
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_GRAY;
        _contentLab.font = FONT(14);
        _contentLab.text = @"优惠券兑换成功，赶紧去下单吧";
    }
    return _contentLab;
}

- (ZYElasticButton *)orderBtn{
    if(!_orderBtn){
        _orderBtn = [ZYElasticButton new];
        _orderBtn.shouldRound = YES;
        _orderBtn.font = FONT(18);
        [_orderBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_orderBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        [_orderBtn setTitle:@"去下单" forState:UIControlStateNormal];
        [_orderBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_orderBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _orderBtn;
}


@end
