//
//  ZYBaseNC.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseNC.h"
#import "ZYBaseVC.h"
#import "UIImage+ZYExtension.h"
#import <objc/runtime.h>

@interface ZYBaseNC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic , assign) id systemPanTarget; //系统侧滑返回代理对象
@property (nonatomic , assign) SEL systemPanHandler; //系统侧滑返回回调

@property (nonatomic , strong) ZYBaseVC *curVC; //用于记录侧滑返回的当前视图控制器
@property (nonatomic , strong) ZYBaseVC *preVC; //用于记录侧滑返回的前一个视图控制器

@property (nonatomic, getter=isPushing) BOOL pushing; //记录push状态，防止多次push

@end

@implementation ZYBaseNC

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, NSSelectorFromString(@"_updateInteractiveTransition:"));
        Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(@"zy_updateInteractiveTransition:"));
        
        if (!class_addMethod([self class], @selector(zy_updateInteractiveTransition:), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self initWidgets];
    [self overrideSwipeToBack];
}

#pragma mark - 重写系统侧滑返回
- (void)overrideSwipeToBack{
    _systemPanTarget  = self.interactivePopGestureRecognizer.delegate;
    _systemPanHandler = NSSelectorFromString(@"handleNavigationTransition:");
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backPanHandler:)];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

#pragma mark - 侧滑返回手势
- (void)backPanHandler:(UIPanGestureRecognizer *)pan{
    if(_systemPanTarget && _systemPanHandler){
        IMP imp = [_systemPanTarget methodForSelector:_systemPanHandler];
        void (*func)(id, SEL, UIPanGestureRecognizer *) = (void *)imp;
        func(_systemPanTarget, _systemPanHandler, pan);
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    _pushing = NO;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    //解决与左滑手势冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    if(self.viewControllers.count == 1){
        return NO;
    }
    UIViewController *lastVC = [self.viewControllers lastObject];
    if([lastVC isKindOfClass:[ZYBaseVC class]]){
        ZYBaseVC *vc = (ZYBaseVC *)lastVC;
        if(!vc.shouldSwipeToBack){
            return NO;
        }
    }else{
        return NO;
    }
    return YES;
}

#pragma mark - UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive] == YES) {
        if (@available(iOS 10.0, *)) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item{
    
}

// deal the gesture of return break off
- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIViewController *vc = [context viewControllerForKey:key];
        if([vc isKindOfClass:[ZYBaseVC class]]){
            ZYBaseVC *bvc = (ZYBaseVC *)vc;
            CGFloat curAlpha = bvc.navigationBarAlpha;
            self.alpha = curAlpha;
        }
    };
    
    // after that, cancel the gesture of return
    if ([context isCancelled] == YES) {
        double cancelDuration = 0;
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    } else {
        // after that, finish the gesture of return
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}

#pragma mark - 替换系统方法
- (void)zy_updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    if([fromVC isKindOfClass:[ZYBaseVC class]] && [toVC isKindOfClass:[ZYBaseVC class]]){
        ZYBaseVC *bFromVC = (ZYBaseVC *)fromVC;
        ZYBaseVC *bToVC = (ZYBaseVC *)toVC;
        CGFloat fromBarBackgroundAlpha = bFromVC.navigationBarAlpha;
        CGFloat toBarBackgroundAlpha = bToVC.navigationBarAlpha;
        CGFloat process = 1.5 * percentComplete;
        CGFloat newBarBackgroundAlpha = fromBarBackgroundAlpha + (toBarBackgroundAlpha - fromBarBackgroundAlpha) * process;
        self.alpha = newBarBackgroundAlpha;
    }
    if([self respondsToSelector:@selector(zy_updateInteractiveTransition:)]){
        [self zy_updateInteractiveTransition:percentComplete];
    }
}

#pragma mark - override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if (_pushing) {
        return;
    } else {
        _pushing = YES;
    }
    UIViewController *lastVC = self.viewControllers.lastObject;
    if([lastVC isKindOfClass:[ZYBaseVC class]]){
        ZYBaseVC *lvc = (ZYBaseVC *)lastVC;
        self.alpha = lvc.navigationBarAlpha;
        if([viewController isKindOfClass:[ZYBaseVC class]]){
            ZYBaseVC *vc = (ZYBaseVC *)viewController;
            [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                             animations:^{
                                 self.alpha = vc.navigationBarAlpha;
                             }];
        }else{
            self.navigationBar.hidden = NO;
            [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                             animations:^{
                                 self.alpha = 1;
                             }];
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if(self.viewControllers.count > 1){
        UIViewController *lastVC = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
        if([lastVC isKindOfClass:[ZYBaseVC class]]){
            ZYBaseVC *vc = (ZYBaseVC *)lastVC;
            [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                             animations:^{
                                 self.alpha = vc.navigationBarAlpha;
                             }];
        }
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([viewController isKindOfClass:[ZYBaseVC class]]){
        ZYBaseVC *vc = (ZYBaseVC *)viewController;
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                         animations:^{
                             self.alpha = vc.navigationBarAlpha;
                         }];
    }
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    UIViewController *lastVC = self.viewControllers.firstObject;
    if([lastVC isKindOfClass:[ZYBaseVC class]]){
        ZYBaseVC *vc = (ZYBaseVC *)lastVC;
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                         animations:^{
                             self.alpha = vc.navigationBarAlpha;
                         }];
    }
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - 初始化各控件样式
- (void)initWidgets{
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:NAVIGATIONBAR_SHADOW_COLOR]];
    [self.navigationBar setBackIndicatorTransitionMaskImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:NAVIGATIONBAR_FONT,
                                                 NSForegroundColorAttributeName:NAVIGATIONBAR_TITLECOLOR}];
}

#pragma mark - 设置透明度
- (void)setAlpha:(CGFloat)alpha{
    _alpha = alpha;
    self.navigationBar.alpha = alpha;
}

@end
