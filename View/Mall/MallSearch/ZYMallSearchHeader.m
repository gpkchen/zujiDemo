//
//  ZYMallSearchHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallSearchHeader.h"

@implementation ZYMallSearchHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self);
        }];
        
        [self addSubview:self.clearBtn];
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(self.clearBtn.width + 56 * UI_H_SCALE);
        }];
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = MEDIUM_FONT(18);
    }
    return _titleLab;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (ZYElasticButton *)clearBtn{
    if(!_clearBtn){
        _clearBtn = [ZYElasticButton new];
        _clearBtn.backgroundColor = UIColor.whiteColor;
        _clearBtn.font = FONT(14);
        [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateNormal];
        [_clearBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateHighlighted];
        [_clearBtn sizeToFit];
    }
    return _clearBtn;
}

@end
