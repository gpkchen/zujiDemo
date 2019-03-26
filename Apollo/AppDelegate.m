//
//  AppDelegate.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "ZYApnsHelper.h"
#import <WebKit/WebKit.h>
#import "ZYScreenshotUtils.h"

//UM
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMShare/UMShare.h>

//jpush
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>

//location
#import "ZYLocationUtils.h"

//views
#import "ZYMainTabVC.h"

//七鱼
#import "QYSDK.h"

//支付
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "ZYPaymentService.h"

//同盾
#import "FMDeviceManager.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic , assign) BOOL haveHandleApns; //是否已经在app启动时处理过推送

@end

@implementation AppDelegate

#pragma mark - 初始化微信支付
- (void)initWechatPay{
    [WXApi registerApp:WechatAppKey];
}

#pragma mark - 初始化IQKeyboardManager
- (void)initKeyboardManager{
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[HFTreeDetailVC class]];
}

#pragma mark - 初始化网易七鱼客服
- (void) initNeteaseQY{
    [[QYSDK sharedSDK] registerAppId:NeteaseQYAppKey appName:NeteaseQYAppName];
}

#pragma mark - 初始化友盟
- (void)initUM{
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure setEncryptEnabled:YES];
    [MobClick setScenarioType:E_UM_NORMAL];
    
    ///友盟分享
    [[UMSocialManager defaultManager] openLog:YES];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = YES;
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WechatAppKey
                                       appSecret:WechatAppSecret
                                     redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine
                                          appKey:WechatAppKey
                                       appSecret:WechatAppSecret
                                     redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:QQAppID
                                       appSecret:QQAppKey
                                     redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:SinaAppKey
                                       appSecret:SinaAppSecret
                                     redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

}

#pragma mark - 初始化jpush
- (void)initJpush:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    BOOL isProduction = NO;
#ifdef Archive_Release
    isProduction = YES;
#else
    if([ZYEnvirUtils utils].envir == ZYEnvirGray || [ZYEnvirUtils utils].envir == ZYEnvirPublish){
        isProduction = YES;
    }else{
        isProduction = NO;
    }
#endif
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushKey
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
}

#pragma mark - 初始化同盾
- (void)initFMDeviceManager{
    //获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    // 准备 SDK 初始化参数
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
#ifdef Archive_Release
    #ifndef DEBUG
        [options setValue:@"product" forKey:@"env"];
    #else
        [options setValue:@"allowd" forKey:@"allowd"];
        [options setValue:@"sandbox" forKey:@"env"];
    #endif
#else
    if([ZYEnvirUtils utils].envir == ZYEnvirGray || [ZYEnvirUtils utils].envir == ZYEnvirPublish){
    #ifndef DEBUG
            [options setValue:@"product" forKey:@"env"];
    #else
            [options setValue:@"allowd" forKey:@"allowd"];
            [options setValue:@"sandbox" forKey:@"env"];
    #endif
    }else{
        [options setValue:@"allowd" forKey:@"allowd"];
        [options setValue:@"sandbox" forKey:@"env"];
    }
#endif
    
    [options setValue:@"zhxc" forKey:@"partner"];
    
    //* SDK 初始化完成，生成 blackBox 的时候就会立即触发此回调 24
    [options setObject:^(NSString *blackBox){

        //添加你的回调逻辑
        printf("同盾设备指纹,回调函数获取到的 blackBox:%s\n",[blackBox UTF8String]);
    } forKey:@"callback"];
    //设置超时时间(单位:秒)
    [options setValue:@"6" forKey:@"timeLimit"];
    
    // 使用上述参数进行 SDK 初始化
    manager->initWithOptions(options);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //加载tabbar图片
    [ZYAppUtils checkTabbarImages];
    //加载接口延签规则
    [[ZYHttpClient client] loadSignRule:NO];
    //刷新apiToken
    if([ZYUser user].silenceLoginAbility){
        [[ZYLoginService service] tokenLogin:NO complete:nil];
    }
    //初始化友盟
    [self initUM];
    //初始化jpush
    [self initJpush:launchOptions];
    //初始化KeyboardManager
    [self initKeyboardManager];
    //初始化网易七鱼
    [self initNeteaseQY];
    //初始化微信支付
    [self initWechatPay];
    //开始监听截屏
    [ZYScreenshotUtils startListen];
    //初始化同盾
    [self initFMDeviceManager];
    //处理推送
    if (launchOptions) {
        NSDictionary* info = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (info) {
            [[ZYApnsHelper helper] handelTask:info from:ZYAPNSSourceAppLaunch];
            _haveHandleApns = YES;
        }
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [ZYMainTabVC shareInstance];
    
    return YES;
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionNone); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    if(!_haveHandleApns){
        [[ZYApnsHelper helper] handelTask:userInfo from:ZYAPNSSourceAppForeground];
    }
}


// iOS 10 Support
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    completionHandler();  // 系统要求执行这个方法
    if(!_haveHandleApns){
        [[ZYApnsHelper helper] handelTask:userInfo from:ZYAPNSSourceAppBackground];
    }
}
#pragma clang diagnostic pop


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (!_haveHandleApns) {
        if(application.applicationState == UIApplicationStateActive) {
            [[ZYApnsHelper helper] handelTask:userInfo from:ZYAPNSSourceAppForeground];
        }else {
            [[ZYApnsHelper helper] handelTask:userInfo from:ZYAPNSSourceAppBackground];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //支付宝
            if ([[url absoluteString] containsString:@"auth_zhima"]) {
                [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                    ZYLog(@"支付宝登录授权结果: %@",resultDic);
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZhiMa_Auth_Notification object:nil userInfo:@{@"resultDic":resultDic}];
                }];
            } else {
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    ZYLog(@"支付宝支付结果：%@",resultDic);
                    int orderState = [resultDic[@"resultStatus"] intValue];
                    [[ZYPaymentService service] alipayResult:orderState];
                }];
            }
        }else if ([url.host isEqualToString:@"pay"]) {
            
            [WXApi handleOpenURL:url delegate:[ZYPaymentService service]];
            
        }else if ([url.host isEqualToString:@"huoti"]) {
            NSString *urlStr = [[url absoluteString] componentsSeparatedByString:@"?"][1];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HuoTi_Auth_Notification object:nil userInfo:@{@"resultStr":[urlStr URLDecode]}];
            
        }
        return YES;
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //支付宝
            if ([[url absoluteString] containsString:@"auth_zhima"]) {
                [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                    ZYLog(@"支付宝登录授权结果: %@",resultDic);
                        [[NSNotificationCenter defaultCenter] postNotificationName:ZhiMa_Auth_Notification object:nil userInfo:@{@"resultDic":resultDic}];
                }];
            } else {
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    ZYLog(@"支付宝支付结果：%@",resultDic);
                    int orderState = [resultDic[@"resultStatus"] intValue];
                    [[ZYPaymentService service] alipayResult:orderState];
                }];
            }
        }else if ([url.host isEqualToString:@"pay"]) {

            [WXApi handleOpenURL:url delegate:[ZYPaymentService service]];

        }else if ([url.host isEqualToString:@"huoti"]) {
            NSString *urlStr = [[url absoluteString] componentsSeparatedByString:@"?"][1];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HuoTi_Auth_Notification object:nil userInfo:@{@"resultStr":[urlStr URLDecode]}];

        }
        return YES;
    }
    return result;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    ZYLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //发起定位
    [[ZYLocationUtils utils] startLocating:NO];
    //检测更新
    [[ZYAppUtils utils] checkUpdate];
    //清零角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    //清除cookies
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    //清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
        }];
    } else {
        // Fallback on earlier versions
    }
}


@end
