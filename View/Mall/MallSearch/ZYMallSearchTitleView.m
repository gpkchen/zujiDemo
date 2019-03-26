//
//  ZYMallSearchTitleView.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallSearchTitleView.h"

@implementation ZYMallSearchTitleView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(280 * UI_H_SCALE, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYTextField *)textField{
    if(!_textField){
        _textField = [ZYTextField new];
        _textField.textColor = WORD_COLOR_BLACK;
        _textField.placeholder = @"搜索你想要";
        _textField.wordLimitNum = 50;
        _textField.placeholderColor = HexRGB(0xcccccc);
        _textField.font = FONT(14);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.clipsToBounds = YES;
        _textField.cornerRadius = 15;
        _textField.backgroundColor = VIEW_COLOR;
        _textField.tintColor = UIColor.blueColor;
        _textField.returnKeyType = UIReturnKeySearch;
        
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"zy_mall_search"];
        
        UIView *leftView = [UIView new];
        leftView.size = CGSizeMake(37, 30);
        [leftView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftView);
        }];
        
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = leftView;
        
    }
    return _textField;
}

#pragma mark - 适配iOS11
- (CGSize)intrinsicContentSize{
    return self.size;
}

@end
