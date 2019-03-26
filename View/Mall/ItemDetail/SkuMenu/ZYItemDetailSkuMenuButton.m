//
//  ZYItemDetailSkuMenuButton.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/12.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailSkuMenuButton.h"

@interface ZYItemDetailSkuMenuButton ()

@end

@implementation ZYItemDetailSkuMenuButton

- (instancetype)init{
    if(self = [super init]){
        self.shouldRound = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.font = FONT(14);
        self.borderWidth = 1;
        [self setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [self setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateSelected];
        [self setTitleColor:HexRGB(0xE8EAED) forState:UIControlStateDisabled];
        
        self.buttonState = ZYItemDetailSkuMenuButtonStateNormal;
    }
    return self;
}

- (void)setButtonState:(ZYItemDetailSkuMenuButtonState)buttonState{
    _buttonState = buttonState;
    
    if(buttonState == ZYItemDetailSkuMenuButtonStateNormal){
        self.borderColor = WORD_COLOR_GRAY;
        self.selected = NO;
        self.enabled = YES;
    }else if(buttonState == ZYItemDetailSkuMenuButtonStateSelected){
        self.borderColor = BTN_COLOR_NORMAL_GREEN;
        self.selected = YES;
        self.enabled = YES;
    }else if(buttonState == ZYItemDetailSkuMenuButtonStateDisable){
        self.selected = NO;
        self.enabled = NO;
        self.borderColor = HexRGB(0xE8EAED);
    }
}

- (void)setValue:(_m_ItemDetail_SkuAttribute_Sub *)value{
    _value = value;
    [self setTitle:value.name forState:UIControlStateNormal];
    CGSize size = [value.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:FONT(14)}
                                           context:nil].size;
    self.size = CGSizeMake(size.width + 32 * UI_H_SCALE, 36 * UI_H_SCALE);
}

@end
