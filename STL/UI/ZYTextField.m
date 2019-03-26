//
//  ZYTextField.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYTextField.h"

@implementation ZYTextField

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addTarget:self
                 action:@selector(selfEditChanged:)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

#pragma mark - 输入框字数限制
- (void)selfEditChanged:(UITextField *)textField{
    if(_wordLimitNum > 0){
        NSString *toBeString = textField.text;
        NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
        if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (toBeString.length > _wordLimitNum) {
                    textField.text = [toBeString substringToIndex:_wordLimitNum];
                }
            }else{//有高亮选择的字符串，则暂不对文字进行统计和限制
                
            }
        }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > _wordLimitNum) {
                textField.text = [toBeString substringToIndex:_wordLimitNum];
            }
        }
    }
}

#pragma mark - setter
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    if(self.placeholder.length > 0){
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        if(_placeholderColor){
            [attributes setValue:_placeholderColor forKey:NSForegroundColorAttributeName];
        }
        if(_placeholderFont){
            [attributes setValue:_placeholderFont forKey:NSFontAttributeName];
        }
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:attributes];
    }
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    
    if(self.placeholder.length > 0){
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        if(_placeholderColor){
            [attributes setValue:_placeholderColor forKey:NSForegroundColorAttributeName];
        }
        if(_placeholderFont){
            [attributes setValue:_placeholderFont forKey:NSFontAttributeName];
        }
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:attributes];
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    if(self.placeholder.length > 0){
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        if(_placeholderColor){
            [attributes setValue:_placeholderColor forKey:NSForegroundColorAttributeName];
        }
        if(_placeholderFont){
            [attributes setValue:_placeholderFont forKey:NSFontAttributeName];
        }
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:attributes];
    }
}

@end
