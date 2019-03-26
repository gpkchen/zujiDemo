//
//  UINavigationController+ZYRouter.m
//  PodLib
//
//  Created by 李明伟 on 2018/4/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UINavigationController+ZYRouter.h"

@implementation UINavigationController (ZYRouter)

// push
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
    isHiddenTabbarWhenPush:(BOOL)isHiddenTabbarWhenPush
                completion:(void(^)(void))completion{
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    viewController.hidesBottomBarWhenPushed = isHiddenTabbarWhenPush;
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}


// pop回上一级
- (void)popViewController:(BOOL)animated completion:(void (^)(void))completion{
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popViewControllerAnimated:animated];
    [CATransaction commit];
}

// pop到指定控制器
- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                 completion:(void (^)(void))completion{
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popToViewController:viewController animated:animated];
    [CATransaction commit];
}

// popToRoot
- (void)popToRootViewController:(BOOL)animated
                     completion:(void(^)(void))completion{
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popToRootViewControllerAnimated:animated];
    [CATransaction commit];
}

@end
