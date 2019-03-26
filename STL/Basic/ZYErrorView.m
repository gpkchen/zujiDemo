//
//  ZYErrorView.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYErrorView.h"

@interface ZYErrorView ()

@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) ZYElasticButton *button;

@end

@implementation ZYErrorView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).mas_offset(32 * UI_H_SCALE);
        make.size.mas_equalTo(self.button.size);
    }];
}

#pragma mark - setter
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    _buttonTitle = buttonTitle;
    if(buttonTitle){
        [self.button setTitle:buttonTitle forState:UIControlStateNormal];
        self.button.hidden = NO;
        CGSize size = [buttonTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:FONT(14)}
                                                context:nil].size;
        [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width + 30, size.height + 18));
        }];
    }else{
        self.button.hidden = YES;
    }
}

- (void)setContentY:(CGFloat)contentY{
    _contentY = contentY;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(contentY);
    }];
}

#pragma mark - getter
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (ZYElasticButton *)button{
    if(!_button){
        _button = [ZYElasticButton new];
        _button.shouldRound = YES;
        _button.backgroundColor = self.backgroundColor;
        _button.borderColor = BTN_COLOR_NORMAL_GREEN;
        _button.borderWidth = 1;
        [_button setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_button setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _button.font = FONT(14);
        _button.hidden = YES;
        _button.size = CGSizeMake(80 * UI_H_SCALE, 32 * UI_H_SCALE);
        
        __weak __typeof__(self) weakSelf = self;
        [_button clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.buttonAction ? : weakSelf.buttonAction();
        }];
    }
    return _button;
}

@end
