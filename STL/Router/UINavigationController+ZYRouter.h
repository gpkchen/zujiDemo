//
//  UINavigationController+ZYRouter.h
//  PodLib
//
//  Created by 李明伟 on 2018/4/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ZYRouter)

/**
 push跳转
  
 @param viewController 目标控制器
 @param animated 是否动画条状
 @param isHiddenTabbarWhenPush 是否隐藏tabbar
 @param completion 完成回调
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
    isHiddenTabbarWhenPush:(BOOL)isHiddenTabbarWhenPush
                completion:(void(^)(void))completion;


/**
 push返回上级控制器
 
 @param animated 是否显示动画
 @param completion 完成回调
 */
- (void)popViewController:(BOOL)animated
               completion:(void (^)(void))completion;


/**
 push返回制定控制器
 
 @param viewController 目标控制器
 @param animated 是否显示动画
 @param completion 完成回调
 */
- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                 completion:(void (^)(void))completion;


/**
 返回根控制器
 
 @param animated 是否显示动画
 @param completion 完成回调
 */
- (void)popToRootViewController:(BOOL)animated
                     completion:(void(^)(void))completion;

@end
