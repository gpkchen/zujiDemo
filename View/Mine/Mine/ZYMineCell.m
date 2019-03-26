//
//  ZYMineCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMineCell.h"

@interface ZYMineCell()

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *numLab;

@end

@implementation ZYMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        self.arrow.hidden = NO;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrow.mas_left).mas_offset(-4);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(14 * UI_H_SCALE, 14 * UI_H_SCALE));
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setNum:(int)num{
    _num = num;
    if(num == 0){
        self.numLab.hidden = YES;
        return;
    }
    self.numLab.hidden = NO;
    if(num <= 99){
        self.numLab.text = [NSString stringWithFormat:@"%d",num];
    }else{
        self.numLab.text = @"99+";
    }
    if(num < 10){
        [self.numLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14 * UI_H_SCALE, 14 * UI_H_SCALE));
        }];
    }else{
        [self.numLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24 * UI_H_SCALE, 14 * UI_H_SCALE));
        }];
    }
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = MEDIUM_FONT(15);
    }
    return _titleLab;
}

- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.textColor = UIColor.whiteColor;
        _numLab.font = FONT(10);
        _numLab.layer.backgroundColor = HexRGB(0xFF5E5E).CGColor;
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.clipsToBounds = YES;
        _numLab.hidden = YES;
        _numLab.cornerRadius = 7 * UI_H_SCALE;
    }
    return _numLab;
}

@end
