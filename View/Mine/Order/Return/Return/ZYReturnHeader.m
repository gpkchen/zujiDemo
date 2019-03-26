
//
//  ZYReturnHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnHeader.h"

@interface ZYReturnHeader()

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;

@end

@implementation ZYReturnHeader

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = HexRGB(0xFFF8D4);
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self).mas_offset(7 * UI_H_SCALE);
        }];
        
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self).mas_offset(32 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLab.text = content;
    
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 * UI_H_SCALE, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:self.contentLab.font}
                                                  context:nil].size.height;
    self.height = contentHeight + 42 * UI_H_SCALE;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = HexRGB(0x4a4a4a);
        _titleLab.font = MEDIUM_FONT(15);
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_GRAY_9B;
        _contentLab.numberOfLines = 0;
        _contentLab.font = FONT(12);
    }
    return _contentLab;
}

@end
