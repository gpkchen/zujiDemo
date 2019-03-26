//
//  ZYPayPenaltyView.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPayPenaltyView.h"

@implementation ZYPayPenaltyView

- (instancetype) init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, ZYPayBarHeight, 0));
        }];
        
        [self addSubview:self.payBar];
        [self.payBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(ZYPayBarHeight);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (ZYPayBar *)payBar{
    if(!_payBar){
        _payBar = [ZYPayBar new];
    }
    return _payBar;
}

- (ZYPayPenaltyFooter *)footer{
    if(!_footer){
        _footer = [ZYPayPenaltyFooter new];
    }
    return _footer;
}

@end
