//
//  ZYVerCodeService.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYVerCodeService.h"
#import "GetVerificationCode.h"

static NSString * const kVerCodeLastSendingTimeStorageKey = @"kVerCodeLastSendingTimeStorageKey";
static NSString * const kVerCodeLastSendingMobileStorageKey = @"kVerCodeLastSendingMobileStorageKey";
const int ZYVerCodeMaxTimeCounting = 60;

@interface ZYVerCodeService ()

@end

@implementation ZYVerCodeService

@synthesize lastSendingTime = _lastSendingTime;
@synthesize lastSendingMobile = _lastSendingMobile;

+ (instancetype)service{
    static ZYVerCodeService *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYVerCodeService alloc] init];
    });
    
    return _instance;
}

- (void)requireVerCode:(ZYVerCodeServiceScene)scene
                mobile:(NSString *)mobile
               showHud:(BOOL)showHud
               complete:(void(^)(BOOL success))complete {
    _p_GetVerificationCode *param = [_p_GetVerificationCode new];
    param.mobile = mobile;
    if(scene == ZYVerCodeServiceSceneLogin){
        param.scene = @"login";
    }
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.lastSendingTime = [NSDate date];
                                self.lastSendingMobile = mobile;
                                !complete ? : complete(YES);
                                
                                NSString *code = responseObj.data[@"code"];
                                if(![NSString isBlank:code]){
                                    [ZYToast showWithTitle:code];
                                }
                                
                                [ZYToast showWithTitle:@"验证码发送成功"];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                                !complete ? : complete(NO);
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            !complete ? : complete(NO);
                        } authFail:nil];
}

- (void)reset{
    _lastSendingTime = nil;
    _lastSendingMobile = nil;
    [NSUserDefaults removeObjectForKey:kVerCodeLastSendingTimeStorageKey];
    [NSUserDefaults removeObjectForKey:kVerCodeLastSendingMobileStorageKey];
}

#pragma mark - setter
- (void)setLastSendingTime:(NSDate *)lastSendingTime{
    _lastSendingTime = lastSendingTime;
    [NSUserDefaults writeWithObject:lastSendingTime forKey:kVerCodeLastSendingTimeStorageKey];
}

- (void)setLastSendingMobile:(NSString *)lastSendingMobile{
    _lastSendingMobile = lastSendingMobile;
    [NSUserDefaults writeWithObject:lastSendingMobile forKey:kVerCodeLastSendingMobileStorageKey];
}

#pragma mark - getter
- (NSDate *)lastSendingTime{
    if(_lastSendingTime){
        return _lastSendingTime;
    }
    NSDate *date = [NSUserDefaults readObjectWithKey:kVerCodeLastSendingTimeStorageKey];
    if(date){
        return date;
    }
    return nil;
}

- (NSString *)lastSendingMobile{
    if(_lastSendingMobile){
        return _lastSendingMobile;
    }
    NSString *lastSendingMobile = [NSUserDefaults readObjectWithKey:kVerCodeLastSendingMobileStorageKey];
    if(lastSendingMobile){
        return lastSendingMobile;
    }
    return nil;
}

- (BOOL)shouldContinueCounting{
    if(!self.lastSendingTime){
        return NO;
    }
    NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:self.lastSendingTime];
    if(difference < ZYVerCodeMaxTimeCounting){
        return YES;
    }
    return NO;
}

- (int)remainTimeCount{
    if(!self.shouldContinueCounting){
        return 0;
    }
    NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:self.lastSendingTime];
    return ZYVerCodeMaxTimeCounting - difference;
}

@end
