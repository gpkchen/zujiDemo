//
//  ZYLoginService.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYLoginService.h"
#import "Login.h"
#import "Logout.h"
#import "SilenceLogin.h"
#import <UMAnalytics/MobClick.h>
#import "JPUSHService.h"
#import "QYSDK.h"

NSString *const ZYLogoutNotification = @"ZYLogoutNotification";
NSString *const ZYMobileLoginSuccessNotification = @"ZYMobileLoginSuccessNotification";
NSString *const ZYTokenAuthFailNotification = @"ZYTokenAuthFailNotification";

@interface ZYLoginService ()

@property (nonatomic , assign) ZYLoginState loginState;
@property (nonatomic , copy) ZYLoginServiceRequireLoginBlock tmpRequireLoginBlock;//临时登录回调，用于登录中状态监测

@end

@implementation ZYLoginService

+ (instancetype)service{
    static ZYLoginService *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYLoginService alloc] init];
    });
    
    return _instance;
}

- (instancetype) init{
    if(self = [super init]){
        _loginState = ZYLoginStateNone;
    }
    return self;
}

#pragma mark - 检测登录（用于要求登录的操作）
- (void) requireLogin:(ZYLoginServiceRequireLoginBlock)block{
    ZYUser *user = [ZYUser user];
    if(_loginState == ZYLoginStateNone || _loginState == ZYLoginStateFail || _loginState == ZYLoginStateTimeOut){
        //未登录、登录失败、登录超时状态
        if([user silenceLoginAbility]){
            [self tokenLogin:YES complete:^(BOOL success) {
                if(success){
                    !block ? : block();
                }else{
                    [[ZYRouter router] goWithoutHead:@"login" withCallBack:^(BOOL isCancel){
                        if(!isCancel){
                            !block ? : block();
                        }
                    }];
                }
            }];
        }else{
            [[ZYRouter router] goWithoutHead:@"login" withCallBack:^(BOOL isCancel){
                if(!isCancel){
                    !block ? : block();
                }
            }];
        }
    }else if(_loginState == ZYLoginStateLogining){
        //登录中（静默登录）
        _tmpRequireLoginBlock = block;
    }else if(_loginState == ZYLoginStateCompleting){
        //登录完成
        !block ? : block();
    }
}

#pragma mark - 电话验证码登录
- (void) mobileCodeLogin:(NSString *)mobile code:(NSString *)code showHud:(BOOL)showHud complete:(ZYLoginServiceLoginBlock)block{
    _loginState = ZYLoginStateLogining;
    _p_Login *param = [[_p_Login alloc] init];
    param.mobile = mobile;
    param.code = code;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask * _Nonnull task, ZYHttpResponse * _Nonnull responseObj) {
                            ZYUser *user = [ZYUser user];
                            if(ZYHttpResponseCodeSuccess == responseObj.code){
                                
                                //将用户信息持久化
                                _m_Login *model = [_m_Login mj_objectWithKeyValues:responseObj.data];
                                user.userId         = model.userId;
                                user.mobile         = mobile;
                                user.refreshToken   = model.refreshToken;
                                user.apiToken       = model.apiToken;
                                user.portraitPath   = model.avatar;
                                [user save];
                                
                                //设置友盟统计
                                [MobClick profileSignInWithPUID:user.userId];
                                
                                //登录成功
                                self.loginState = ZYLoginStateCompleting;
                                
                                //绑定jpush
                                [self setAliasToJPushServer];
                                
                                //登录成功发送通知
                                [[NSNotificationCenter defaultCenter] postNotificationName:ZYMobileLoginSuccessNotification object:nil];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                                
                                //删除用户信息
                                [user removeLoginInfo];
                                
                                //登录失败
                                self.loginState = ZYLoginStateFail;
                                
                                //解除友盟绑定
                                [MobClick profileSignOff];
                                
                                //解绑jpush
                                [self deleteAliasToJPushServer];
                            }
                            !block ? : block(responseObj.code == ZYHttpResponseCodeSuccess);
                        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }else if(error.code == ZYHttpErrorCodeSystemError){
                                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                            }
                            
                            //登录失败
                            self.loginState = ZYLoginStateTimeOut;
                            
                            !block ? : block(NO);
                            
                            //解绑jpush
                            [self deleteAliasToJPushServer];
                            
                        } authFail:nil];
}

#pragma mark - 静默登录
- (void) tokenLogin:(BOOL)showHud complete:(ZYLoginServiceLoginBlock)block{
    _loginState = ZYLoginStateLogining;
    _p_SilenceLogin *param = [[_p_SilenceLogin alloc] init];
    param.refreshToken = [ZYUser user].refreshToken;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask * _Nonnull task, ZYHttpResponse * _Nonnull responseObj) {
                            ZYUser *user = [ZYUser user];
                            if(ZYHttpResponseCodeSuccess == responseObj.code){
                                
                                //将用户信息持久化
                                _m_SilenceLogin *model  = [_m_SilenceLogin mj_objectWithKeyValues:responseObj.data];
                                user.apiToken       = model.apiToken;
                                user.portraitPath   = model.avatar;
                                [user save];
                                
                                //设置友盟统计
                                [MobClick profileSignInWithPUID:user.userId];
                                
                                //登录成功
                                self.loginState = ZYLoginStateCompleting;
                                
                                //检测用户登录状态
                                if(self.tmpRequireLoginBlock){
                                    self.tmpRequireLoginBlock();
                                }
                                
                                //绑定jpush
                                [self setAliasToJPushServer];
                                
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                                
                                //删除用户信息
                                [[ZYUser user] removeLoginInfo];
                                
                                //登录失败
                                self.loginState = ZYLoginStateFail;
                                
                                //解除友盟绑定
                                [MobClick profileSignOff];
                                
                                //登录失败
                                self.loginState = ZYLoginStateFail;
                                
                                //解绑jpush
                                [self deleteAliasToJPushServer];
                            }
                            !block ? : block(responseObj.code == ZYHttpResponseCodeSuccess);
                            
                            self.tmpRequireLoginBlock = nil;
                            
                        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }else if(error.code == ZYHttpErrorCodeSystemError){
                                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                            }
                            
                            //登录失败
                            self.tmpRequireLoginBlock = nil;
                            
                            //登录失败
                            self.loginState = ZYLoginStateTimeOut;
                            
                            !block ? : block(NO);
                            
                            //解绑jpush
                            [self deleteAliasToJPushServer];
                        } authFail:nil];
}

#pragma mark - 退出登录
- (void) logout:(ZYLoginServiceLogoutCompleteBlock)block{
    
    if([ZYUser user].isUserLogined){
        _p_Logout *param = [[_p_Logout alloc] init];
        [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
            if (responseObj.success) {
                ZYUser *user = [ZYUser user];
                [user removeLoginInfo];
                self.loginState = ZYLoginStateNone;
                !block ? : block();
                //退出成功发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:ZYLogoutNotification object:nil];
                //解除友盟绑定
                [MobClick profileSignOff];
                //解绑jpush
                [self deleteAliasToJPushServer];
                //退出七鱼
                [[QYSDK sharedSDK] logout:^(){}];
            } else {
                [ZYToast showWithTitle:responseObj.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(error.code == ZYHttpErrorCodeTimeOut){
                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
            }else if(error.code == ZYHttpErrorCodeNoNet){
                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
            }else if(error.code == ZYHttpErrorCodeSystemError){
                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
            }
        } authFail:nil];
    }else{
        ZYUser *user = [ZYUser user];
        [user removeLoginInfo];
        self.loginState = ZYLoginStateNone;
        !block ? : block();
        //退出成功发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYLogoutNotification object:nil];
        //解除友盟绑定
        [MobClick profileSignOff];
        //解绑jpush
        [self deleteAliasToJPushServer];
        //退出七鱼
        [[QYSDK sharedSDK] logout:^(){}];
    }
}

#pragma mark - 绑定JPush
- (void)setAliasToJPushServer{
    __weak __typeof__(self) weakSelf = self;
    ZYUser *user = [ZYUser user];
    if(user.userId){
        [JPUSHService setAlias:user.userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if(iResCode){
                [weakSelf setAliasToJPushServer];
            }
        } seq:0];
    }
}

#pragma mark - 解绑JPush
- (void)deleteAliasToJPushServer{
    __weak __typeof__(self) weakSelf = self;
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if(iResCode){
            [weakSelf deleteAliasToJPushServer];
        }
    } seq:0];
}

@end
