//
//  ZYDetailCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYDetailCell.h"

@implementation ZYDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentLab.mas_left).mas_offset(15 * UI_H_SCALE);
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

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_BLACK;
        _contentLab.font = FONT(15);
        _contentLab.textAlignment = NSTextAlignmentRight;
    }
    return _contentLab;
}

#pragma mark - setter
- (void)setShowArrow:(BOOL)showArrow{
    _showArrow = showArrow;
    
    if(showArrow){
        self.arrow.hidden = NO;
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.arrow.mas_left).mas_offset(-3 * UI_H_SCALE);
            make.left.greaterThanOrEqualTo(self.titleLab.mas_right).mas_offset(20 * UI_H_SCALE);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        self.arrow.hidden = YES;
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.left.greaterThanOrEqualTo(self.titleLab.mas_right).mas_offset(20 * UI_H_SCALE);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
