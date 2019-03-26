
//
//  ZYAddressChoiseView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddressChoiseView.h"

@interface ZYAddressChoiseView ()

@property (nonatomic , strong) UIView *btnBack;

@end

@implementation ZYAddressChoiseView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.btnBack];
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(55 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.btnBack.mas_top);
        make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT);
    }];
    
    [self.btnBack addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.btnBack);
        make.height.mas_equalTo(55 * UI_H_SCALE);
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

- (UIView *)btnBack{
    if(!_btnBack){
        _btnBack = [UIView new];
        _btnBack.backgroundColor = [UIColor whiteColor];
    }
    return _btnBack;
}

- (ZYElasticButton *)addBtn{
    if(!_addBtn){
        _addBtn = [ZYElasticButton new];
        _addBtn.shouldAnimate = NO;
        [_addBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _addBtn.font = FONT(18);
    }
    return _addBtn;
}

@end
