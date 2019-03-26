//
//  ZYShareView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYShareView.h"

@interface ZYShareView ()

@end

@implementation ZYShareView

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
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0));
    }];
}

#pragma mark - getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.backgroundColor;
    }
    return _tableView;
}

- (ZYShareHeader *)header{
    if(!_header){
        _header = [ZYShareHeader new];
    }
    return _header;
}

- (ZYShareFooter *)footer{
    if(!_footer){
        _footer = [ZYShareFooter new];
    }
    return _footer;
}

@end
