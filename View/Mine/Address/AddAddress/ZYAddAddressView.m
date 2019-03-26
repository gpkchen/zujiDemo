//
//  ZYAddAddressView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddAddressView.h"

@implementation ZYAddAddressView

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
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
    }];
    
    [self.footer addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footer).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.footer).mas_offset(-15 * UI_H_SCALE);
        make.top.equalTo(self.footer).mas_offset(20 * UI_H_SCALE);
        make.height.mas_equalTo(49 * UI_H_SCALE);
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

- (ZYTextField *)receiverText{
    if(!_receiverText){
        _receiverText = [ZYTextField new];
        _receiverText.textColor = WORD_COLOR_BLACK;
        _receiverText.font = FONT(15);
        _receiverText.wordLimitNum = 10;
    }
    return _receiverText;
}

- (ZYTextField *)mobileText{
    if(!_mobileText){
        _mobileText = [ZYTextField new];
        _mobileText.textColor = WORD_COLOR_BLACK;
        _mobileText.font = FONT(15);
        _mobileText.wordLimitNum = 11;
        _mobileText.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _mobileText;
}

- (ZYTextView *)addressText{
    if(!_addressText){
        _addressText = [ZYTextView new];
        _addressText.textColor = WORD_COLOR_BLACK;
        _addressText.font = FONT(15);
        _addressText.placeholder = @"请输入详细地址";
        _addressText.placeholderTextColor = WORD_COLOR_GRAY;
        _addressText.wordLimitNum = 125;
    }
    return _addressText;
}

- (ZYElasticButton *)saveBtn{
    if(!_saveBtn){
        _saveBtn = [ZYElasticButton new];
        _saveBtn.shouldRound = YES;
        [_saveBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.font = FONT(18);
    }
    return _saveBtn;
}

- (UIView *)footer{
    if(!_footer){
        _footer = [UIView new];
        _footer.backgroundColor = VIEW_COLOR;
    }
    return _footer;
}

#pragma mark - override
- (BOOL)resignFirstResponder{
    [self.receiverText resignFirstResponder];
    [self.mobileText resignFirstResponder];
    [self.addressText resignFirstResponder];
    return [super resignFirstResponder];
}

@end
