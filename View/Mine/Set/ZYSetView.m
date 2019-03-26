//
//  ZYSetView.m
//  Apollo
//
//  Created by shaxia on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYSetView.h"

@implementation ZYSetView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.logoutButton];
        [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).mas_offset(-DOWN_DANGER_HEIGHT);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).mas_offset(CNBMinHeight);
            make.bottom.equalTo(self.logoutButton.mas_top);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:UIColor.whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, 0, 0);
        _tableView.contentOffset = CGPointMake(0, -_tableView.scrollIndicatorInsets.top);
    }
    return _tableView;
}

- (ZYElasticButton *)logoutButton{
    if (!_logoutButton) {
        _logoutButton = [ZYElasticButton new];
        [_logoutButton setBackgroundColor:VIEW_COLOR];
        [_logoutButton.titleLabel setFont:FONT(18)];
        [_logoutButton setTitleColor:HexRGB(0x4a4a4a)  forState:(UIControlStateNormal)];
        [_logoutButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
    }
    return _logoutButton;
}

@end
