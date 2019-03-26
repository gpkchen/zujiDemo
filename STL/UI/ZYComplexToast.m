//
//  ZYComplexToast.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/28.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYComplexToast.h"

@interface ZYComplexToast()

@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *detailLab;

@end

@implementation ZYComplexToast

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = HexRGBAlpha(0x18191A, 0.9);
        self.size = CGSizeMake(160 * UI_H_SCALE, 120 * UI_H_SCALE);
        self.cornerRadius = 2;
        
        [self addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(15 * UI_H_SCALE);
        }];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(16.5 * UI_H_SCALE);
            make.left.equalTo(self).mas_offset(10 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-10 * UI_H_SCALE);
        }];
        
        [self addSubview:self.detailLab];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(38.5 * UI_H_SCALE);
            make.left.equalTo(self).mas_offset(10 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-10 * UI_H_SCALE);
        }];
    }
    return self;
}

+ (void)showSuccessWithTitle:(NSString *)title detail:(NSString *)detail{
    [self showWithIcon:[UIImage imageNamed:@"zy_toast_success_icon"]
                 title:title
                detail:detail
               centerY:SCREEN_HEIGHT / 2
            completion:nil];
}

+ (void)showMessageWithTitle:(NSString *)title detail:(NSString *)detail{
    [self showWithIcon:[UIImage imageNamed:@"zy_toast_message_icon"]
                 title:title
                detail:detail
               centerY:SCREEN_HEIGHT / 2
            completion:nil];
}

+ (void)showFailureWithTitle:(NSString *)title detail:(NSString *)detail{
    [self showWithIcon:[UIImage imageNamed:@"zy_toast_failure_icon"]
                 title:title
                detail:detail
               centerY:SCREEN_HEIGHT / 2
            completion:nil];
}

+ (void)showSuccessWithTitle:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY{
    [self showWithIcon:[UIImage imageNamed:@"zy_toast_success_icon"]
                 title:title
                detail:detail
               centerY:centerY
            completion:nil];
}

+ (void)showMessageWithTitle:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY{
    [self showWithIcon:[UIImage imageNamed:@"zy_toast_message_icon"]
                 title:title
                detail:detail
               centerY:centerY
            completion:nil];
}

+ (void)showFailureWithTitle:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY{
    [self showWithIcon:[UIImage imageNamed:@"zy_toast_failure_icon"]
                 title:title
                detail:detail
               centerY:centerY
            completion:nil];
}

+ (void)showWithIcon:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY completion:(void(^)(void))completion{
    ZYComplexToast *toast = [ZYComplexToast new];
    toast.iconIV.image = icon;
    toast.titleLab.text = title;
    toast.detailLab.text = detail;
    toast.center = CGPointMake(SCREEN_WIDTH / 2, centerY);
    toast.alpha = 0;
    [toast makeVisibleWindow];
    [UIView animateWithDuration:0.3
                     animations:^{
                         toast.alpha = 1;
                     }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                         animations:^{
                             toast.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             toast.hidden = YES;
                             if(completion){
                                 completion();
                             }
                         }];
    });
}

#pragma mark - 显示window
- (void)makeVisibleWindow {
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    if (keyWindows) {
        [keyWindows makeKeyWindow];
    }
}

#pragma mark - getter
- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = UIColor.whiteColor;
        _titleLab.font = FONT(15);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)detailLab{
    if(!_detailLab){
        _detailLab = [UILabel new];
        _detailLab.textColor = UIColor.whiteColor;
        _detailLab.font = FONT(12);
        _detailLab.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLab;
}

@end
