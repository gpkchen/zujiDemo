//
//  ZYApnsHelper.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**app收到通知的三种操作情况*/
typedef NS_ENUM(int,ZYAPNSSource) {
    ZYAPNSSourceAppLaunch = 1,      //点击通知栏的通知启动app收到的通知
    ZYAPNSSourceAppBackground = 2,  //app在后台点击通知启动app
    ZYAPNSSourceAppForeground = 3,  //app在激活情况下收到通知
};

@interface ZYApnsHelper : NSObject

/**单例*/
+ (instancetype) helper;

/**判断是否有推送权限*/
+ (void) checkNotificationAuthority:(void(^)(BOOL hasAuthority))block;
/**请求推送权限*/
+ (void) askNotificationAuthority;

/**添加接收到的推送任务*/
- (void)handelTask:(NSDictionary *)info from:(ZYAPNSSource)source;
/**处理待处理的推送任务，用于ZHAPNSSourceAppLaunch的情况*/
- (void)handlePendingTask;

@end
