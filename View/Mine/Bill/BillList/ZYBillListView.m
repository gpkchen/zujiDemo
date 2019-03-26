//
//  ZYBillListView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillListView.h"

@interface ZYBillListView ()

@property (nonatomic , strong) UIView *backView;

@end

@implementation ZYBillListView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
    }];
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
    }
    return _tableView;
}

- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

@end
