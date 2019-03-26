//
//  ZYItemDetailUpView.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpView.h"

@interface ZYItemDetailUpView ()

@property (nonatomic , strong) UIView *skuBack;
@property (nonatomic , strong) UIView *serviceBack;
@property (nonatomic , strong) UIView *dragBack;

@end

@implementation ZYItemDetailUpView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.alwaysBounceVertical = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
