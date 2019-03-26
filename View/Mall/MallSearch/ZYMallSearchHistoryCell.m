//
//  ZYMallSearchHistoryCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallSearchHistoryCell.h"

@interface ZYMallSearchHistoryCell()

@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation ZYMallSearchHistoryCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = VIEW_COLOR;
        self.cornerRadius = ZYMallSearchHistoryCellHeight / 2.0;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_GRAY_9B;
        _titleLab.font = FONT(14);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

@end
