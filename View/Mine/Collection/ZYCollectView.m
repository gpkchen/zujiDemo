//
//  ZYCollectView.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/22.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYCollectView.h"

@implementation ZYCollectView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        self.tableView.frame = CGRectMake(0, CNBMinHeight, SCREEN_WIDTH, SCREEN_HEIGHT - CNBMinHeight);
        [self addSubview:self.tableView];
        
        self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT - DOWN_DANGER_HEIGHT - 50 * UI_H_SCALE, SCREEN_WIDTH, 50 * UI_H_SCALE);
        [self addSubview:self.toolBar];
        
        [self.toolBar addSubview:self.allBtn];
        [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.toolBar);
            make.width.mas_equalTo(100 * UI_H_SCALE);
        }];
        
        [self.toolBar addSubview:self.allIV];
        [self.allIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolBar).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.toolBar);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.toolBar addSubview:self.allLab];
        [self.allLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.allIV.mas_right).mas_offset(5 * UI_H_SCALE);
            make.centerY.equalTo(self.toolBar);
        }];
        
        [self.toolBar addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.toolBar);
            make.height.mas_equalTo(1);
        }];
        
        [self.toolBar addSubview:self.deleteAllBtn];
        [self.deleteAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.toolBar).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.toolBar);
            make.size.mas_equalTo(CGSizeMake(90 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.contentOffset = CGPointMake(0, -_tableView.scrollIndicatorInsets.top);
        _tableView.allowsMultipleSelectionDuringEditing = YES;
    }
    return _tableView;
}

- (UIView *)toolBar{
    if(!_toolBar){
        _toolBar = [UIView new];
        _toolBar.backgroundColor = UIColor.whiteColor;
        _toolBar.hidden = YES;
    }
    return _toolBar;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = HexRGBAlpha(0x18191A, 0.1);
    }
    return _line;
}

- (ZYElasticButton *)deleteAllBtn{
    if(!_deleteAllBtn){
        _deleteAllBtn = [ZYElasticButton new];
        [_deleteAllBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_deleteAllBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _deleteAllBtn.font = FONT(15);
        [_deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteAllBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_deleteAllBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    }
    return _deleteAllBtn;
}

- (ZYElasticButton *)allBtn{
    if(!_allBtn){
        _allBtn = [ZYElasticButton new];
        _allBtn.backgroundColor = UIColor.whiteColor;
    }
    return _allBtn;
}

- (UIImageView *)allIV{
    if(!_allIV){
        _allIV = [UIImageView new];
        _allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_normal"];
    }
    return _allIV;
}

- (UILabel *)allLab{
    if(!_allLab){
        _allLab = [UILabel new];
        _allLab.textColor = WORD_COLOR_BLACK;
        _allLab.font = FONT(15);
        _allLab.text = @"全选";
    }
    return _allLab;
}

@end
