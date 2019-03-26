//
//  ZYToast.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYToast.h"
#import "ZYMacro.h"
#import "UIView+ZYExtension.h"
#import "Masonry.h"

@interface ZYToast ()

@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation ZYToast

- (instancetype)init{
    self = [super init];
    if(self){
        self.windowLevel = powf(10, 7);
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        self.layer.masksToBounds = YES;
        
        _titleLab = [UILabel new];
        _titleLab.font = FONT(14);
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.layer.masksToBounds = YES;
        _titleLab.numberOfLines = 0;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_titleLab];
    }
    return self;
}

+ (void)showWithTitle:(NSString *)title centerY:(CGFloat)centerY completion:(void(^)(void))completion{
    ZYToast *toast = [ZYToast new];
    toast.titleLab.text = title;
    CGSize size = [toast.titleLab sizeThatFits:CGSizeMake(SCREEN_WIDTH - 20 * UI_H_SCALE - 60 * UI_H_SCALE, CGFLOAT_MAX)];
    toast.size = CGSizeMake(size.width + 60 * UI_H_SCALE,size.height + 20 * UI_H_SCALE);
    toast.layer.cornerRadius = (size.height + 20 * UI_H_SCALE) / 2.0;
    toast.titleLab.frame = CGRectMake(30 * UI_H_SCALE, 10 * UI_H_SCALE, size.width,size.height);
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

+ (void)showWithTitle:(NSString *)title completion:(void(^)(void))completion{
    [self showWithTitle:title centerY:SCREEN_HEIGHT / 2 completion:completion];
}

+ (void)showWithTitle:(NSString *)title centerY:(CGFloat)centerY{
    [self showWithTitle:title centerY:centerY completion:nil];
}

+ (void)showWithTitle:(NSString *)title{
    [self showWithTitle:title centerY:SCREEN_HEIGHT / 2 completion:nil];
}

#pragma mark - 显示window
- (void)makeVisibleWindow {
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    if (keyWindows) {
        [keyWindows makeKeyWindow];
    }
}


@end

