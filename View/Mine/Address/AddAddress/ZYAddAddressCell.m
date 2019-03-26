
//
//  ZYAddAddressCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddAddressCell.h"

@implementation ZYAddAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.arrow.mas_left).mas_offset(-5 * UI_H_SCALE);
            make.left.equalTo(self.contentView).mas_offset(115 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.defaultWitch];
        [self.defaultWitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setShowArrow:(BOOL)showArrow{
    _showArrow = showArrow;
    
    self.arrow.hidden = !showArrow;
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
        _contentLab.textColor = WORD_COLOR_GRAY;
        _contentLab.font = FONT(15);
    }
    return _contentLab;
}

- (UISwitch *)defaultWitch{
    if(!_defaultWitch){
        _defaultWitch = [UISwitch new];
    }
    return _defaultWitch;
}

@end
