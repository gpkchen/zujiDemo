//
//  UIAlertView+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewActionBlock)(NSInteger index);

@interface UIAlertView (ZYExtension)

- (UIAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                   clickAction:(UIAlertViewActionBlock)clickAction;

@end
