//
//  ZYCouponChoiseView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCouponChoiseView.h"

@implementation ZYCouponChoiseView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
    }];
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.contentOffset = CGPointMake(0, -_tableView.scrollIndicatorInsets.top);
    }
    return _tableView;
}

@end
