//
//  ZYMallView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallView.h"

@implementation ZYMallView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, TABBAR_HEIGHT, 0));
    }];
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.backgroundColor;
    }
    return _tableView;
}

@end
