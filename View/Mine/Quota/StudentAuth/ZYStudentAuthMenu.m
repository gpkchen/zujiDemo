//
//  ZYStudentAuthMenu.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYStudentAuthMenu.h"

#define ZYStudentAuthMenuCellHeight (50 * UI_H_SCALE)

@implementation ZYStudentAuthMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
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
        _titleLab.font = FONT(15);
    }
    return _titleLab;
}

- (UIImageView *)selectionIV{
    if(!_selectionIV){
        _selectionIV = [UIImageView new];
        _selectionIV.image = [UIImage imageNamed:@"zy_selection_selected"];
    }
    return _selectionIV;
}

@end



@interface ZYStudentAuthMenu()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYTableView *tableView;

@end

@implementation ZYStudentAuthMenu

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

#pragma mark - public
- (void)show{
    [self.tableView reloadData];
    self.panelView = self.tableView;
    [super show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYStudentAuthMenuCell";
    ZYStudentAuthMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYStudentAuthMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLab.text = self.titles[indexPath.row];
    cell.separator.hidden = indexPath.row == 0;
    if(indexPath.row == _selectedIndex){
        cell.selectionIV.hidden = NO;
    }else{
        cell.selectionIV.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYStudentAuthMenuCellHeight;
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
    
    [self dismiss:nil];
    !_selectAction ? : _selectAction((int)indexPath.row);
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.size = CGSizeMake(SCREEN_WIDTH, ZYStudentAuthMenuCellHeight * 6 + DOWN_DANGER_HEIGHT);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
