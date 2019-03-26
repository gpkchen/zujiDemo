//
//  ZYAppUtils.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**一些实用工具*/
@interface ZYAppUtils : NSObject

/**单例*/
+ (instancetype) utils;

/**打开连接*/
+ (void) openURL:(NSString *)url;

/**检测是否安装支付宝*/
+(BOOL) isInstallAliPay;

/**检测tabbar图片配置*/
+ (void)checkTabbarImages;

/**更新检测*/
- (void)checkUpdate;

@end
