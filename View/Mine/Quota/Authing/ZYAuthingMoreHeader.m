//
//  ZYAuthingMoreHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAuthingMoreHeader.h"

@interface ZYAuthingMoreHeader()

@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation ZYAuthingMoreHeader

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(18);
        _titleLab.text = @"继续完成任务，可以获得更多额度";
    }
    return _titleLab;
}

@end
