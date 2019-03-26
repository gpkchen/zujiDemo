//
//  ZYPublishMomentHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPublishMomentHeader.h"

@interface ZYPublishMomentHeader ()<UITextViewDelegate>

@property (nonatomic , strong) UIView *back;

@end

@implementation ZYPublishMomentHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.back];
        [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(10 * UI_H_SCALE, 0, 0, 0));
        }];
        
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(10 * UI_H_SCALE, 0, 30 * UI_H_SCALE, 0));
        }];
        
        [self addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(30 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    !_block ? : _block(textView.text);
    self.numLab.text = [NSString stringWithFormat:@"%lu/2000",(unsigned long)textView.text.length];
}


#pragma mark - getter
- (UIView *)back{
    if(!_back){
        _back = [UIView new];
        _back.backgroundColor = UIColor.whiteColor;
    }
    return _back;
}

- (ZYTextView *)textView{
    if(!_textView){
        _textView = [ZYTextView new];
        _textView.font = FONT(14);
        _textView.placeholder = @"请输入内容(￣▽￣)／";
        _textView.placeholderTextColor = WORD_COLOR_GRAY_9B;
        _textView.wordLimitNum = 2000;
        _textView.textColor = WORD_COLOR_BLACK;
        _textView.c_delegate = self;
    }
    return _textView;
}

- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.textColor = WORD_COLOR_GRAY_9B;
        _numLab.font = FONT(14);
        _numLab.text = @"0/2000";
    }
    return _numLab;
}

@end
