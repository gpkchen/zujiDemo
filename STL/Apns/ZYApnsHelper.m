//
//  ZYApnsHelper.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYApnsHelper.h"
#import "ZYApnsModel.h"
#import "ZYQuotaApnsAlert.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface ZYApnsHelper ()

@property (nonatomic , strong) ZYApnsModel *pendingModel; //待处理的推送任务
@property (nonatomic , strong) ZYQuotaApnsAlert *quotaAlert;

@end

@implementation ZYApnsHelper

+ (instancetype) helper{
    static ZYApnsHelper *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYApnsHelper alloc] init];
    });
    
    return _instance;
}

#pragma mark - 添加接收到的推送任务
- (void)handelTask:(NSDictionary *)info from:(ZYAPNSSource)source{
    ZYApnsModel *model = [[ZYApnsModel alloc] initWithDictionary:info];
    if(source == ZYAPNSSourceAppLaunch){
        _pendingModel = model;
    }else if(source == ZYAPNSSourceAppBackground || source == ZYAPNSSourceAppForeground){
        [self dealApns:model];
    }
}

#pragma mark - 处理待处理的推送任务，用于ZHAPNSSourceAppLaunch的情况
- (void)handlePendingTask{
    if(!_pendingModel){
        return;
    }
    
    [self dealApns:_pendingModel];
    _pendingModel = nil;
}

#pragma mark - 分发推送任务
- (void) dealApns:(ZYApnsModel *)model{
    switch (model.showType) {
        case ZHApnsShowTypeNone:{
            if(model.url){
                [[ZYRouter router]go:model.url];
            }
        }
            break;
        case ZHApnsShowTypeAlert:{
            NSMutableArray *titles = [NSMutableArray array];
            if(model.btnTitle1){
                [titles addObject:model.btnTitle1];
            }
            if(model.btnTitle2){
                [titles addObject:model.btnTitle2];
            }
            if(!titles.count){
                [titles addObject:@"我知道了"];
            }
            [ZYAlert showWithTitle:nil
                           content:model.content
                      buttonTitles:titles
                      buttonAction:^(ZYAlert *alert, int index) {
                          [alert dismiss];
                          if(index == titles.count - 1 && model.url){
                              [[ZYRouter router] go:model.url];
                          }
                      }];
        }
            break;
        case ZHApnsShowTypeGainAmount:{
            [self.quotaAlert showWithType:ZYQuotaApnsAlertShowTypePassGainAmount amount:[model.remarks doubleValue]];
        }
            break;
        case ZHApnsShowTypePassAuth:{
            [self.quotaAlert showWithType:ZYQuotaApnsAlertShowTypePassAuth amount:0];
        }
            break;
        case ZHApnsShowTypeGainAmountImprove:{
            [self.quotaAlert showWithType:ZYQuotaApnsAlertShowTypePassGainAmountImprove amount:[model.remarks doubleValue]];
        }
            break;
        case ZHApnsShowTypePassAuthImprove:{
            [self.quotaAlert showWithType:ZYQuotaApnsAlertShowTypePassAuthImprove amount:0];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 判断是否有推送权限
+ (void) checkNotificationAuthority:(void(^)(BOOL hasAuthority))block{
    if (@available(iOS 10 , *)){
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (settings.authorizationStatus != UNAuthorizationStatusAuthorized){
                    // 没权限
                    !block ? : block(NO);
                }else{
                    !block ? : block(YES);
                }
            });
        }];
    }else if (@available(iOS 8 , *)){
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
            !block ? : block(NO);
        }else{
            !block ? : block(YES);
        }
    }else{
        !   block ? : block(NO);
    }
}

#pragma mark - 请求推送权限
+ (void) askNotificationAuthority{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"请打开“允许通知”以便我们提供更精准的服务！"
                                          cancelButtonTitle:@"暂不"
                                          otherButtonTitles:@[@"去设置"]
                                                clickAction:^(NSInteger index) {
                                                    if(1 == index){
                                                        [ZYAppUtils openURL:UIApplicationOpenSettingsURLString];
                                                    }
                                                }];
    [alert show];
}

#pragma mark - getter
- (ZYQuotaApnsAlert *)quotaAlert{
    if(!_quotaAlert){
        _quotaAlert = [ZYQuotaApnsAlert new];
    }
    return _quotaAlert;
}

@end
