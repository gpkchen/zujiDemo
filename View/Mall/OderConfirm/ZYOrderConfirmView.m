//
//  ZYOrderConfirmView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderConfirmView.h"

@implementation ZYOrderConfirmView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
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

#pragma mark - getter
- (ZYPayBar *)payBar{
    if(!_payBar){
        _payBar = [ZYPayBar new];
    }
    return _payBar;
}

- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (ZYOrderConfirmFooter *)footer{
    if(!_footer){
        _footer = [ZYOrderConfirmFooter new];
    }
    return _footer;
}

- (ZYElasticButton *)helpBtn{
    if(!_helpBtn){
        _helpBtn = [ZYElasticButton new];
        _helpBtn.backgroundColor = UIColor.clearColor;
        [_helpBtn setImage:[UIImage imageNamed:@"zy_order_buy_off_help"] forState:UIControlStateNormal];
        [_helpBtn setImage:[UIImage imageNamed:@"zy_order_buy_off_help"] forState:UIControlStateHighlighted];
    }
    return _helpBtn;
}

@end
