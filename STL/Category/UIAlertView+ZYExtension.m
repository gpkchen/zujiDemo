//
//  UIAlertView+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UIAlertView+ZYExtension.h"
#import <objc/runtime.h>

const static void *kUIAlertViewActionStorageKey = "kUIAlertViewActionStorageKey";

@implementation UIAlertView (ZYExtension)

- (UIAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                   clickAction:(UIAlertViewActionBlock)clickAction{
    self = [self initWithTitle:title
                       message:message
                      delegate:self
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:nil];
    for(NSString *title in otherButtonTitles){
        [self addButtonWithTitle:title];
    }
    if(clickAction){
        objc_setAssociatedObject(self, kUIAlertViewActionStorageKey, clickAction, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIAlertViewActionBlock clickAction = objc_getAssociatedObject(alertView, kUIAlertViewActionStorageKey);
    !clickAction ? : clickAction(buttonIndex);
}

@end
