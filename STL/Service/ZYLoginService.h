//
//  ZYLoginService.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**登录后回调*/
typedef void (^ZYLoginServiceLoginBlock)(BOOL success);
/**登录状态检测后回调*/
typedef void (^ZYLoginServiceRequireLoginBlock)(void);
/**退出登录成功回调*/
typedef void (^ZYLoginServiceLogoutCompleteBlock)(void);

/**退出登录通知名*/
extern NSString *const ZYLogoutNotification;
/**电话号码登录成功通知名*/
extern NSString *const ZYMobileLoginSuccessNotification;
/**Token验证失败通知名*/
extern NSString *const ZYTokenAuthFailNotification;


/**登录状态*/
typedef NS_ENUM(int , ZYLoginState){
    ZYLoginStateNone = 0,       //未登录
    ZYLoginStateLogining = 1,   //登录中
    ZYLoginStateCompleting = 2, //登录完成
    ZYLoginStateFail = 3,       //登录失败
    ZYLoginStateTimeOut = 4,    //登录超时
};

@interface ZYLoginService : NSObject

/**当前登录状态*/
@property (nonatomic , assign , readonly) ZYLoginState loginState;

/**单例*/
+ (instancetype)service;

/**检测登录（用于要求登录的操作）*/
- (void) requireLogin:(ZYLoginServiceRequireLoginBlock)block;
/**电话验证码登录*/
- (void) mobileCodeLogin:(NSString *)mobile code:(NSString *)code showHud:(BOOL)showHud complete:(ZYLoginServiceLoginBlock)block;
/**静默登录*/
- (void) tokenLogin:(BOOL)showHud complete:(ZYLoginServiceLoginBlock)block;
/**退出登录*/
- (void) logout:(ZYLoginServiceLogoutCompleteBlock)block;

@end
