//
//  ZYAddContactCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddContactCell.h"

@implementation ZYAddContactCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.leftLabel];
        [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.textView];
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH - 170 * UI_H_SCALE);
            make.right.mas_equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)leftLabel{
    if(!_leftLabel){
        _leftLabel = [UILabel new];
        _leftLabel.textColor = WORD_COLOR_BLACK;
        _leftLabel.font = FONT(15);
    }
    return _leftLabel;
}

- (ZYTextField *)textView{
    if(!_textView){
        _textView = [ZYTextField new];
        _textView.textColor = WORD_COLOR_BLACK;
        _textView.font = FONT(15);
    }
    return _textView;
}

@end
