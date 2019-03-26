//
//  ZYReturnExpressSelectorCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnExpressSelectorCell.h"

@implementation ZYReturnExpressSelectorCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundColor = VIEW_COLOR;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.cb];
        [self.cb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(34 + 30 * UI_H_SCALE);
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

- (ZYCheckBox *)cb{
    if(!_cb){
        _cb = [ZYCheckBox new];
        _cb.normalImage = [UIImage imageNamed:@"zy_selection_normal"];
        _cb.selectedImage = [UIImage imageNamed:@"zy_selection_selected"];
    }
    return _cb;
}

@end
