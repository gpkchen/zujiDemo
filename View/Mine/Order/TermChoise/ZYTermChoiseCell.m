//
//  ZYTermChoiseCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYTermChoiseCell.h"

@interface ZYTermChoiseCell ()

@property (nonatomic , strong) UIImageView *selectionIV;

@end

@implementation ZYTermChoiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.selectionIV];
        [self.selectionIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setIsSelectedTerm:(BOOL)isSelectedTerm{
    _isSelectedTerm = isSelectedTerm;
    if(isSelectedTerm){
        self.selectionIV.image = [UIImage imageNamed:@"zy_selection_selected"];
    }else{
        self.selectionIV.image = [UIImage imageNamed:@"zy_selection_normal"];
    }
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
        _selectionIV.image = [UIImage imageNamed:@"zy_selection_normal"];
    }
    return _selectionIV;
}

@end
