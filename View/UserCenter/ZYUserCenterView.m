//
//  ZYUserCenterView.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUserCenterView.h"

@interface ZYUserCenterView()

@property (nonatomic , strong) UIView *line;

@end

@implementation ZYUserCenterView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.width.mas_equalTo(30 * UI_H_SCALE + self.backBtn.width);
            make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        }];
        
        [self addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.bottom.equalTo(self.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.width.mas_equalTo(30 * UI_H_SCALE + self.editBtn.width);
            make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        }];
        
        [self addSubview:self.navigationBar];
        [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        }];
        
        [self.navigationBar addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.navigationBar);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.navigationBar addSubview:self.backOnBarBtn];
        [self.backOnBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navigationBar).mas_offset(3.5);
            make.bottom.equalTo(self.navigationBar.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.width.mas_equalTo(30 * UI_H_SCALE + self.backOnBarBtn.width);
            make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        }];
        
        [self.navigationBar addSubview:self.editOnBarBtn];
        [self.editOnBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navigationBar);
            make.bottom.equalTo(self.navigationBar.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.width.mas_equalTo(30 * UI_H_SCALE + self.editOnBarBtn.width);
            make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
    }
    return _tableView;
}

- (ZYElasticButton *)backBtn{
    if(!_backBtn){
        _backBtn = [ZYElasticButton new];
        _backBtn.backgroundColor = UIColor.clearColor;
        UIImage *backImg = [UIImage imageNamed:@"zy_usercenter_back_btn"];
        [_backBtn setImage:backImg forState:UIControlStateNormal];
        [_backBtn setImage:backImg forState:UIControlStateHighlighted];
        _backBtn.size = backImg.size;
    }
    return _backBtn;
}

- (ZYElasticButton *)editBtn{
    if(!_editBtn){
        _editBtn = [ZYElasticButton new];
        _editBtn.backgroundColor = UIColor.clearColor;
        [_editBtn setImage:[UIImage imageNamed:@"zy_usercenter_edit_btn"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"zy_usercenter_edit_btn"] forState:UIControlStateHighlighted];
        [_editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        _editBtn.font = FONT(12);
        [_editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        _editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        [_editBtn sizeToFit];
    }
    return _editBtn;
}

- (UIView *)navigationBar{
    if(!_navigationBar){
        _navigationBar = [UIView new];
        _navigationBar.backgroundColor = UIColor.whiteColor;
        _navigationBar.alpha = 0;
    }
    return _navigationBar;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = NAVIGATIONBAR_SHADOW_COLOR;
    }
    return _line;
}

- (ZYElasticButton *)backOnBarBtn{
    if(!_backOnBarBtn){
        _backOnBarBtn = [ZYElasticButton new];
        _backOnBarBtn.backgroundColor = UIColor.clearColor;
        UIImage *backImg = [UIImage imageNamed:@"zy_navigation_back_btn"];
        [_backOnBarBtn setImage:backImg forState:UIControlStateNormal];
        [_backOnBarBtn setImage:backImg forState:UIControlStateHighlighted];
        _backOnBarBtn.size = backImg.size;
    }
    return _backOnBarBtn;
}

- (ZYElasticButton *)editOnBarBtn{
    if(!_editOnBarBtn){
        _editOnBarBtn = [ZYElasticButton new];
        _editOnBarBtn.backgroundColor = UIColor.clearColor;
        [_editOnBarBtn setImage:[UIImage imageNamed:@"zy_usercenter_edit_btn_green"] forState:UIControlStateNormal];
        [_editOnBarBtn setImage:[UIImage imageNamed:@"zy_usercenter_edit_btn_green"] forState:UIControlStateHighlighted];
        [_editOnBarBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        _editOnBarBtn.font = FONT(12);
        [_editOnBarBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateNormal];
        [_editOnBarBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateHighlighted];
        _editOnBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        [_editOnBarBtn sizeToFit];
    }
    return _editOnBarBtn;
}

@end
