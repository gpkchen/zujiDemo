//
//  ZYToast.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**提示框控件*/
@interface ZYToast : UIWindow

+ (void)showWithTitle:(NSString *)title centerY:(CGFloat)centerY completion:(void(^)(void))completion;
+ (void)showWithTitle:(NSString *)title completion:(void(^)(void))completion;
+ (void)showWithTitle:(NSString *)title centerY:(CGFloat)centerY;
+ (void)showWithTitle:(NSString *)title;

@end
