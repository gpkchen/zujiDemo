//
//  ZYStudentAuthCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYStudentAuthCell.h"

@implementation ZYStudentAuthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.titleLab.textColor = WORD_COLOR_BLACK;
        self.contentLab.textColor = WORD_COLOR_GRAY;
        
        [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.left.greaterThanOrEqualTo(self.titleLab.mas_right).mas_offset(20 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYTextField *)textField{
    if(!_textField){
        _textField = [ZYTextField new];
        _textField.textColor = WORD_COLOR_BLACK;
        _textField.placeholder = @"请输入学校名称";
        _textField.placeholderColor = WORD_COLOR_GRAY;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = FONT(15);
        _textField.wordLimitNum = 50;
    }
    return _textField;
}

@end
