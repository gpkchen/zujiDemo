//
//  ZYRouter.m
//  PodLib
//
//  Created by 李明伟 on 2018/4/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYRouter.h"
#import "ZYRouterManager.h"
#import "ZYMacro.h"
#import "ZYLocalRouterRule.h"

@interface ZYRouter ()

@property (nonatomic , strong) NSMutableArray<id<ZYRouterRole>> *rules; //规则集合

@end

@implementation ZYRouter

+ (instancetype) router{
    static ZYRouter *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYRouter alloc] init];
    });
    
    return _instance;
}

- (instancetype)init{
    if(self = [super init]){
        [self addRule:[ZYLocalRouterRule new]];
        self.protocolHead = ProtocolHead;
        self.protocolEncodeKey = [ZYEnvirUtils utils].protocolEncodeKey;
        self.nc = [ZYBaseNC class];
    }
    return self;
}

#pragma mark - 检测url合法性
+ (BOOL)checkUrl:(NSString *)url{
    if(!url){
        ZYLog(@"协议“%@”不合法!",url);
        return NO;
    }
    if(![url hasPrefix:[ZYRouter router].protocolHead]){
        ZYLog(@"协议“%@”不合法!",url);
        return NO;
    }
    ZYLog(@"go:“%@”",url);
    return YES;
}

#pragma mark - 添加规则
- (void) addRule:(id<ZYRouterRole>)rule{
    if(!_rules){
        _rules = [NSMutableArray array];
    }
    if(rule){
        [_rules addObject:rule];
    }
}

#pragma mark - 执行外部协议
- (ZYProtocol *)go:(NSString *)url{
    return [self go:url withCallBack:nil isPush:YES completion:nil];
}

- (ZYProtocol *)go:(NSString *)url withCallBack:(id)callBack{
    return [self go:url withCallBack:callBack isPush:YES completion:nil];
}

- (ZYProtocol *)go:(NSString *)url isPush:(BOOL)isPush{
    return [self go:url withCallBack:nil isPush:isPush completion:nil];
}

- (ZYProtocol *)go:(NSString *)url withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion{
    if ([ZYRouter checkUrl:url]) {
        ZYProtocol *protocol   = [[ZYProtocol alloc]initWithOutUrl:url];
        protocol.isPush = isPush;
        protocol.callBack = callBack;
        [self redirect:protocol completion:completion];
        return protocol;
    }
    return nil;
}

#pragma mark - 执行内部部协议
- (ZYProtocol *)goWithoutHead:(NSString *)url{
    return [self goWithoutHead:url withCallBack:nil isPush:YES completion:nil];
}

- (ZYProtocol *)goWithoutHead:(NSString *)url withCallBack:(id)callBack{
    return [self goWithoutHead:url withCallBack:callBack isPush:YES completion:nil];
}

- (ZYProtocol *)goWithoutHead:(NSString *)url isPush:(BOOL)isPush{
    return [self goWithoutHead:url withCallBack:nil isPush:isPush completion:nil];
}

- (ZYProtocol *)goWithoutHead:(NSString *)url withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion{
    url = [NSString stringWithFormat:@"%@%@",_protocolHead,url];
    if([ZYRouter checkUrl:url]){
        ZYProtocol *protocol = [[ZYProtocol alloc]initWithInnerUrl:url];
        protocol.isPush = isPush;
        protocol.callBack = callBack;
        [self redirect:protocol completion:completion];
        return protocol;
    }
    return nil;
}

#pragma mark - 内部控制器操作
- (ZYProtocol *)goVC:(NSString *)url{
    return [self goVC:url withCallBack:nil isPush:YES completion:nil];
}

- (ZYProtocol *)goVC:(NSString *)url withCallBack:(id)callBack{
    return [self goVC:url withCallBack:callBack isPush:YES completion:nil];
}

- (ZYProtocol *)goVC:(NSString *)url isPush:(BOOL)isPush{
    return [self goVC:url withCallBack:nil isPush:isPush completion:nil];
}

- (ZYProtocol *)goVC:(NSString *)url withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion{
    url = [NSString stringWithFormat:@"%@%@",_protocolHead,url];
    if([ZYRouter checkUrl:url]){
        ZYProtocol *protocol = [[ZYProtocol alloc]initWithInnerUrl:url];
        protocol.isPush = isPush;
        protocol.callBack = callBack;
        [self redirect:protocol completion:completion];
        return protocol;
    }
    return nil;
}

#pragma mark - 执行协议对象
- (void)goProtocol:(ZYProtocol *_Nullable)protocol{
    [self goProtocol:protocol withCallBack:nil isPush:YES completion:nil];
}

- (void)goProtocol:(ZYProtocol *_Nullable)protocol withCallBack:(id _Nullable)callBack{
    [self goProtocol:protocol withCallBack:callBack isPush:YES completion:nil];
}

- (void)goProtocol:(ZYProtocol *)protocol isPush:(BOOL)isPush{
    [self goProtocol:protocol withCallBack:nil isPush:isPush completion:nil];
}

- (void)goProtocol:(ZYProtocol *)protocol withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion{
    protocol.isPush = isPush;
    protocol.callBack = callBack;
    [self redirect:protocol completion:completion];
}

#pragma mark - 执行协议以后路由做调整处理
- (void)redirect:(ZYProtocol *)protocol completion:(void(^)(void))completion{
    __block id<ZYRouterRole> existedRole = nil;
    for(id<ZYRouterRole> role in _rules){
        if([role respondsToSelector:@selector(targets)]){
            NSArray *targets = [role targets];
            [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *target = (NSString *)obj;
                if([target isEqualToString:protocol.target]){
                    *stop = true;
                    existedRole = role;
                }
            }];
        }
        if(existedRole && [existedRole respondsToSelector:@selector(redirect:completion:)]){
            [existedRole redirect:protocol completion:completion];
            return;
        }
    }
    if (protocol.isPush) {
        [[ZYRouterManager manager] push:protocol.target
                               animated:YES
                               callBack:protocol.callBack
                              paramsDic:protocol.params
                 isHiddenTabbarWhenPush:YES
                             completion:completion];
    }else{
        [[ZYRouterManager manager] present:protocol.target
                                  animated:YES
                                  callBack:protocol.callBack
                                 paramsDic:protocol.params
                                completion:completion];
    }
}

- (void) returnToRoot{
//    UIViewController *topVC = [ZYMainTabVC shareInstance].currentNC;
//    if([topVC isKindOfClass:[UINavigationController class]]){
//        UINavigationController *nc = (UINavigationController *)topVC;
//        [topVC dismissViewControllerAnimated:NO completion:^{
//            [nc popToRootViewControllerAnimated:NO];
//        }];
//    }
    NSMutableArray *vcs = [NSMutableArray array];
    UIViewController *topVC = [ZYMainTabVC shareInstance].currentNC;
    if([topVC isKindOfClass:[UINavigationController class]]){
        UINavigationController *nc = (UINavigationController *)topVC;
        [nc popToRootViewControllerAnimated:NO];
    }
    while (topVC.presentedViewController && ([topVC.presentedViewController isKindOfClass:[UIViewController class]] || [topVC.presentedViewController isKindOfClass:[UINavigationController class]])) {
        topVC = topVC.presentedViewController;
        [vcs addObject:topVC];
    }
    for(UIViewController *vc in vcs){
        [vc dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - back
- (void)back{
    if([ZYRouterManager manager].navigationController){
        [[ZYRouterManager manager].navigationController popViewControllerAnimated:YES];
        return;
    }
    if([ZYRouterManager manager].navigationController.presentingViewController){
        [[ZYRouterManager manager].navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if([ZYRouterManager manager].viewController.presentingViewController){
        [[ZYRouterManager manager].viewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

#pragma mark - push vc
- (void)push:(UIViewController *)vc{
    [self push:vc completion:nil];
}

- (void)push:(UIViewController *)vc completion:(void(^)(void))completion{
    if([ZYRouterManager manager].navigationController){
        [CATransaction begin];
        [CATransaction setCompletionBlock:completion];
        vc.hidesBottomBarWhenPushed = YES;
        [[ZYRouterManager manager].navigationController pushViewController:vc animated:YES];
        [CATransaction commit];
    }
}

#pragma mark - present vc
- (void)present:(UIViewController *)vc{
    [self present:vc completion:nil identifier:nil];
}

- (void)present:(UIViewController *)vc completion:(void(^)(void))completion{
    [self present:vc completion:nil identifier:nil];
}

- (void)present:(UIViewController *)vc completion:(void(^)(void))completion identifier:(NSString *)identifier{
    UINavigationController *nc = [ZYRouterManager manager].navigationController;
    if(identifier && [identifier isEqualToString:nc.identifier]){
        [CATransaction begin];
        [CATransaction setCompletionBlock:completion];
        vc.hidesBottomBarWhenPushed = YES;
        [[ZYRouterManager manager].navigationController pushViewController:vc animated:YES];
        [CATransaction commit];
        return;
    }
    UINavigationController *navi = [[_nc alloc]initWithRootViewController:vc];
    navi.identifier = identifier;
    navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[ZYRouterManager manager].viewController presentViewController:navi animated:YES completion:completion];
}

@end
