//
//  ZYStudentSchoolListView.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYStudentSchoolListView.h"
#import "PulldownSchool.h"

#define ZYStudentSchoolListViewCellHeight (50 * UI_H_SCALE)

@implementation ZYStudentSchoolListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = FONT(15);
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.textAlignment = NSTextAlignmentRight;
    }
    return _titleLab;
}

@end



@interface ZYStudentSchoolListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYTableView *tableView;

@end

@implementation ZYStudentSchoolListView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        self.frame = CGRectMake(SCREEN_WIDTH - 319 * UI_H_SCALE,
                                ZYStudentSchoolListViewCellHeight,
                                319 * UI_H_SCALE,
                                ZYStudentSchoolListViewCellHeight * 4);
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _schools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYStudentSchoolListViewCell";
    ZYStudentSchoolListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYStudentSchoolListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.separator.hidden = indexPath.row == 0;
    _m_PulldownSchool *model = self.schools[indexPath.row];
    cell.titleLab.text = model.schoolName;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYStudentSchoolListViewCellHeight;
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
    
    _m_PulldownSchool *model = self.schools[indexPath.row];
    !_selectAction ? : _selectAction(model);
}

#pragma mark - setter
- (void)setSchools:(NSArray *)schools{
    _schools = schools;
    
    [self.tableView reloadData];
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.backgroundColor;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
