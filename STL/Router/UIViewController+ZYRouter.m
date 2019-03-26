//
//  UIViewController+ZYRouter.m
//  PodLib
//
//  Created by 李明伟 on 2018/4/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UIViewController+ZYRouter.h"

static NSString * const kDicParamKey = @"kDicParamKey";
static NSString * const kReturnDicParamKey = @"kReturnDicParamKey";
static NSString * const kCallBackKey = @"kCallBackKey";
static NSString * const kIdentifierKey = @"kIdentifierKey";

@implementation UIViewController (ZYRouter)

#pragma mark - getter/setter
- (NSDictionary*)dicParam{
    return objc_getAssociatedObject(self, &kDicParamKey);
}

- (void)setDicParam:(NSDictionary *)dicParam{
    objc_setAssociatedObject(self, &kDicParamKey,
                             dicParam,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *) returnDicParam{
    return objc_getAssociatedObject(self, &kReturnDicParamKey);
}

- (void) setReturnDicParam:(NSDictionary *)returnDicParam{
    objc_setAssociatedObject(self,
                             &kReturnDicParamKey,
                             returnDicParam,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id) callBack{
    return objc_getAssociatedObject(self, &kCallBackKey);
}

- (void) setCallBack:(id)callBack{
    objc_setAssociatedObject(self,
                             &kCallBackKey,
                             callBack,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *) identifier{
    return objc_getAssociatedObject(self, &kIdentifierKey);
}

- (void) setIdentifier:(NSString *)identifier{
    objc_setAssociatedObject(self,
                             &kIdentifierKey,
                             identifier,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL) dynamicCheckIsExistClassWithviewController:(NSString *)viewController{
    NSString *classStr = [NSString stringWithFormat:@"%@",viewController];
    const char *className = [classStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    Class newClass = objc_getClass(className);
    if (newClass == nil) {
        // 进入该判断,表示该project里面，没有该类
        ZYLog(@"路由错误：控制器\"%@\"不存在！",viewController);
        return NO;
    }
    return YES;
}

+ (void) dynamicDeliverWithViewController:(UIViewController *)viewController
                                      dic:(NSDictionary *)dic{
    // 处理传递数据
    if (dic != nil) {
        //单独把对象整体给控制器
        [viewController setDicParam:dic];
    }
}

// 动态检测instance对象里面是否存在verifyPropertyName属性
- (BOOL) dynamicCheckIsExistProperty:(NSString *)propertyName{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:propertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}


// dismiss到第一个present的控制器
- (void)dismissToRootViewControllerAnimated:(BOOL)animated
                                 completion:(void (^)(void))completion{
    
    /**
     1、注意区分presentedViewController与presentingViewController
     2、通过present，A->B
     3、A.presentedViewController 是B
     4、B.presentingViewController 是A
     */
    
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [vc dismissViewControllerAnimated:YES completion:nil];
    [CATransaction commit];
}

// 接受pop、dismiss回传的值
- (void)receivePreviousControllerWithParamsDic:(NSDictionary *)paramsDic{
    self.returnDicParam = paramsDic;
}

@end
