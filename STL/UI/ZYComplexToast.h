//
//  ZYComplexToast.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/28.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYComplexToast : UIWindow

+ (void)showSuccessWithTitle:(NSString *)title detail:(NSString *)detail;
+ (void)showMessageWithTitle:(NSString *)title detail:(NSString *)detail;
+ (void)showFailureWithTitle:(NSString *)title detail:(NSString *)detail;
+ (void)showSuccessWithTitle:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY;
+ (void)showMessageWithTitle:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY;
+ (void)showFailureWithTitle:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY;
+ (void)showWithIcon:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail centerY:(CGFloat)centerY completion:(void(^)(void))completion;

@end

