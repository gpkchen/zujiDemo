//
//  ZYBillConfirmView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillConfirmView.h"

@implementation ZYBillConfirmView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.payBar];
    [self.payBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ZYPayBarHeight);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.payBar.mas_top);
        make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT);
    }];
    
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = VIEW_COLOR;
    }
    return _tableView;
}

- (ZYPayBar *)payBar{
    if(!_payBar){
        _payBar = [ZYPayBar new];
    }
    return _payBar;
}



@end
