//
//  ZYRouter.h
//  PodLib
//
//  Created by 李明伟 on 2018/4/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYProtocol.h"
#import "UIViewController+ZYRouter.h"


/**路由规则代理*/
@protocol ZYRouterRole <NSObject>

@required
/**执行规则*/
- (void)redirect:(ZYProtocol *)protocol completion:(void(^)(void))completion;
/**目标集合*/
- (NSArray *)targets;

@end


/**路由调度*/
@interface ZYRouter : NSObject

/**获取单例*/
+ (instancetype)router;

/**协议头*/
@property (nonatomic , copy) NSString *protocolHead;
/**协议加解密Key*/
@property (nonatomic , copy) NSString *protocolEncodeKey;
/**导航控制器类*/
@property (nonatomic , strong) Class nc;


/**检测协议合法性*/
+ (BOOL) checkUrl:(NSString *)url;

/**添加路由规则*/
- (void) addRule:(id<ZYRouterRole>)rule;

//外部协议操作方法
- (ZYProtocol *)go:(NSString *)url;
- (ZYProtocol *)go:(NSString *)url withCallBack:(id)callBack;
- (ZYProtocol *)go:(NSString *)url isPush:(BOOL)isPush;
- (ZYProtocol *)go:(NSString *)url withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion;

//内部协议操作方法
- (ZYProtocol *)goWithoutHead:(NSString *)url;
- (ZYProtocol *)goWithoutHead:(NSString *)url withCallBack:(id)callBack;
- (ZYProtocol *)goWithoutHead:(NSString *)url isPush:(BOOL)isPush;
- (ZYProtocol *)goWithoutHead:(NSString *)url withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion;

//内部控制器操作方法
- (ZYProtocol *)goVC:(NSString *)url;
- (ZYProtocol *)goVC:(NSString *)url withCallBack:(id)callBack;
- (ZYProtocol *)goVC:(NSString *)url isPush:(BOOL)isPush;
- (ZYProtocol *)goVC:(NSString *)url withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion;

//协议对象操作方法
- (void)goProtocol:(ZYProtocol *)protocol;
- (void)goProtocol:(ZYProtocol *)protocol withCallBack:(id)callBack;
- (void)goProtocol:(ZYProtocol *)protocol isPush:(BOOL)isPush;
- (void)goProtocol:(ZYProtocol *)protocol withCallBack:(id)callBack isPush:(BOOL)isPush completion:(void(^)(void))completion;

//控制器跳转
- (void)back;
- (void)returnToRoot;
- (void)push:(UIViewController *)vc;
- (void)push:(UIViewController *)vc completion:(void(^)(void))completion;
- (void)present:(UIViewController *)vc;
- (void)present:(UIViewController *)vc completion:(void(^)(void))completion;
- (void)present:(UIViewController *)vc completion:(void(^)(void))completion identifier:(NSString *)identifier;

@end
