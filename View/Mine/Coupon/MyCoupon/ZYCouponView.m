//
//  ZYCouponView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCouponView.h"

@interface ZYCouponView ()


@end

@implementation ZYCouponView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.exchangeBtn];
    [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-DOWN_DANGER_HEIGHT);
        make.height.mas_equalTo(50 * UI_H_SCALE);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, DOWN_DANGER_HEIGHT + 50 * UI_H_SCALE, 0));
    }];
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, 0, 0);
        _tableView.contentOffset = CGPointMake(0, -_tableView.scrollIndicatorInsets.top);
    }
    return _tableView;
}

- (ZYElasticButton *)exchangeBtn{
    if(!_exchangeBtn){
        _exchangeBtn = [ZYElasticButton new];
        _exchangeBtn.font = FONT(15);
        [_exchangeBtn setTitle:@"兑换优惠券" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        [_exchangeBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_exchangeBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _exchangeBtn;
}

@end
