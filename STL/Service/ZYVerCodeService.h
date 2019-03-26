//
//  ZYVerCodeService.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**验证码发送场景*/
typedef NS_ENUM(int , ZYVerCodeServiceScene) {
    ZYVerCodeServiceSceneLogin = 1,//登录时发送验证码
};

/**倒计时秒数*/
extern const int ZYVerCodeMaxTimeCounting;

/**短信验证码服务*/
@interface ZYVerCodeService : NSObject

/**上次发送的时间*/
@property (nonatomic , strong , readonly) NSDate *lastSendingTime;
/**上次发送的手机号*/
@property (nonatomic , strong , readonly) NSString *lastSendingMobile;
/**是否需要继续计时*/
@property (nonatomic , assign , readonly) BOOL shouldContinueCounting;
/**倒计时剩余时间*/
@property (nonatomic , assign , readonly) int remainTimeCount;

/**单例*/
+ (instancetype)service;

/**发送验证码*/
- (void)requireVerCode:(ZYVerCodeServiceScene)scene mobile:(NSString *)mobile showHud:(BOOL)showHud complete:(void(^)(BOOL success))complete;

/**重置记录*/
- (void)reset;

@end
