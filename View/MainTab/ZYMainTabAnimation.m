//
//  ZYMainTabAnimation.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMainTabAnimation.h"

@implementation ZYMainTabAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.15;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获取fromVc和toVc
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = nil;;
    UIView *toView = nil;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        // fromVc 的view
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        // toVc的view
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else {
        // fromVc 的view
        fromView = fromVc.view;
        // toVc的view
        toView = toVc.view;
    }
    
    // 转场环境
    UIView *containView = [transitionContext containerView];
    containView.backgroundColor = VIEW_COLOR;
    [containView addSubview:fromView];
    [containView addSubview:toView];
    
    CGFloat offset = SCREEN_WIDTH / 5;
    toView.frame = CGRectMake(_isLeft ? offset : -offset, 0, containView.frame.size.width, containView.frame.size.height);
    fromView.alpha = 1;
    toView.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = CGAffineTransformTranslate(fromView.transform, self.isLeft ? -offset : offset, 0);
        toView.transform = CGAffineTransformTranslate(toView.transform, self.isLeft ? -offset : offset, 0);
        fromView.alpha = 0;
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

@end
