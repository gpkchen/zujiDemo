//
//  ZYBillDetailView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillDetailView.h"

@interface ZYBillDetailView ()

@property (nonatomic , strong) UIView *btnBack;

@end

@implementation ZYBillDetailView

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
        make.height.mas_equalTo(70 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.btnBack.mas_top);
        make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT);
    }];
    
    [self.btnBack addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnBack).mas_offset(30 * UI_H_SCALE);
        make.right.equalTo(self.btnBack).mas_offset(-30 * UI_H_SCALE);
        make.top.equalTo(self.btnBack).mas_offset(10 * UI_H_SCALE);
        make.bottom.equalTo(self.btnBack).mas_offset(-10 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
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

- (ZYElasticButton *)payBtn{
    if(!_payBtn){
        _payBtn = [ZYElasticButton new];
        _payBtn.shouldRound = YES;
        [_payBtn setTitle:@"支付全部账单" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_payBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_payBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        [_payBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateDisabled];
        _payBtn.font = FONT(18);
    }
    return _payBtn;
}

- (ZYBillDetailHeader *)header{
    if(!_header){
        _header = [ZYBillDetailHeader new];
    }
    return _header;
}

@end
