//
//  ZYCancelOrderMenu.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCancelOrderMenu.h"


@interface ZYCancelOrderMenuCell ()

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIImageView *selectionIV;

@end

@implementation ZYCancelOrderMenuCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundColor = VIEW_COLOR;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.selectionIV];
        [self.selectionIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(16);
    }
    return _titleLab;
}

- (UIImageView *)selectionIV{
    if(!_selectionIV){
        _selectionIV = [UIImageView new];
    }
    return _selectionIV;
}

@end




@interface ZYCancelOrderMenu()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYElasticButton *confirmBtn;
@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) ZYTableView *tableView;

@property (nonatomic , strong) NSArray *reasons;
@property (nonatomic , assign) int selectedIndex;

@end

@implementation ZYCancelOrderMenu

- (instancetype)init{
    if(self = [super init]){
        _selectedIndex = 0;
        
        [self.panel addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.bottom.equalTo(self.panel).mas_offset(-DOWN_DANGER_HEIGHT);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panel);
            make.centerY.equalTo(self.panel.mas_top).mas_offset(28 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self.panel);
            make.size.mas_equalTo(CGSizeMake(30 + 30 * UI_H_SCALE, 56 * UI_H_SCALE));
        }];
        
        [self.panel addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.bottom.equalTo(self.confirmBtn.mas_top);
            make.top.equalTo(self.panel).mas_offset(56 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYCancelOrderMenuCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    cell.selectionIV.image = nil;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionIV.image = [UIImage imageNamed:@"zy_mine_order_selection_icon"];
    _selectedIndex = (int)indexPath.row;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reasons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYCancelOrderMenuCell";
    ZYCancelOrderMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYCancelOrderMenuCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    cell.titleLab.text = self.reasons[indexPath.row];
    if(indexPath.row == _selectedIndex){
        cell.selectionIV.image = [UIImage imageNamed:@"zy_mine_order_selection_icon"];
    }else{
        cell.selectionIV.image = nil;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - override
- (void)show{
    self.panelView = self.panel;
    [super show];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.size = CGSizeMake(SCREEN_WIDTH, 327 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
        _panel.backgroundColor = UIColor.whiteColor;
    }
    return _panel;
}

- (ZYElasticButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [ZYElasticButton new];
        _confirmBtn.shouldAnimate = NO;
        [_confirmBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _confirmBtn.font = FONT(16);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        __weak __typeof__(self) weakSelf = self;
        [_confirmBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
            !weakSelf.confirmBlock ? : weakSelf.confirmBlock(weakSelf.reasons[weakSelf.selectedIndex]);
        }];
    }
    return _confirmBtn;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(20);
        _titleLab.text = @"取消订单";
    }
    return _titleLab;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        _closeBtn.backgroundColor = UIColor.whiteColor;
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
        }];
    }
    return _closeBtn;
}

- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)reasons{
    if(!_reasons){
        _reasons = @[@"我不想租了",@"信息填写错误，重新拍",@"其他原因"];
    }
    return _reasons;
}

@end
