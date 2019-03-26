//
//  UIViewController+ZYRouter.h
//  PodLib
//
//  Created by 李明伟 on 2018/4/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZYRouter)

/** 跳转后控制器能拿到的参数*/
@property (nonatomic , strong) NSDictionary *dicParam;
/** 返回后控制器能拿到的参数*/
@property (nonatomic , strong) NSDictionary *returnDicParam;
/** 跳转后控制器能拿到的回调*/
@property (nonatomic , strong) id callBack;
/** 唯一标识*/
@property (nonatomic , strong) NSString *identifier;

/**
 检测，project中是否含有viewController类
 
 @param viewController 类名
 @return bool
 */
+ (BOOL)dynamicCheckIsExistClassWithviewController:(NSString *)viewController;

/**
 传递数据
 
 @param viewController 目标视图控制器
 @param dic 参数
 */
+ (void)dynamicDeliverWithViewController:(UIViewController *)viewController
                                     dic:(NSDictionary *)dic;

/**
 检测对象里面是否存在propertyName属性
 
 @param propertyName 属性名
 @return bool
 */
- (BOOL)dynamicCheckIsExistProperty:(NSString *)propertyName;

/**
 present返回根控制器
 
 @param animated 是否显示动画
 @param completion 完成回调
 */
- (void)dismissToRootViewControllerAnimated:(BOOL)animated
                                 completion:(void (^)(void))completion;


/**
 接收返回时回传的值
 
 @param paramsDic 参数
 */
- (void)receivePreviousControllerWithParamsDic:(NSDictionary *)paramsDic;

@end
