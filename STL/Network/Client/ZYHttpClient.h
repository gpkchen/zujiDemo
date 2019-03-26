//
//  ZYHttpClient.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ZYBaseParam.h"
#import "ZYBaseModel.h"
#import "ZYHttpResponse.h"

/**默认分页大小*/
extern NSString * const ZYRequestDefaultPageSize;
/**无网络错误信息*/
extern NSString * const ZYHttpErrorMessageNoNet;
/**请求超时错误信息*/
extern NSString * const ZYHttpErrorMessageNetTimeOut;
/**服务器错误信息*/
extern NSString * const ZYHttpErrorMessageSystemError;


/**网络状态改变通知*/
extern NSString * const ZYNetworkReachabilityStatusChangedNotification;


typedef NS_ENUM(int , ZYHttpErrorCode) {
    ZYHttpErrorCodeTimeOut = -1001,     //网络超时
    ZYHttpErrorCodeNoNet = -1009,       //无网络连接
    ZYHttpErrorCodeSystemError = -1011, //服务端炸了
    ZYHttpErrorCodeTokenError = 0,      //Token验证失败
};

/**http请求工具*/
@interface ZYHttpClient : NSObject

/**网络连接*/
@property (nonatomic , assign , readonly) AFNetworkReachabilityStatus reachabilityStatus;

/**单例*/
+ (instancetype)client;


/**
 获取接口验签规则
 */
- (void)loadSignRule:(BOOL)showHud;

/**
 刷新apiToken
 */
- (void)refreshApiToken:(BOOL)showHud;

/**
 上传设备信息
 */
- (void)uploadDeviceInfo;

/**
 *  POST请求
 *
 *  @param param    参数
 *  @param showHud  是否显示加载动画
 *  @param success  请求成功回调
 *  @param failure  请求失败回调
 *  @param authFail 刷新token彻底失败回调
 *
 *  @return NSURLSessionDataTask任务对象
 */
- (NSURLSessionDataTask *)post:(ZYBaseParam *)param
                       showHud:(BOOL)showHud
                       success:(void (^)(NSURLSessionDataTask *task, ZYHttpResponse *responseObj))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                      authFail:(void (^)(void))authFail;


/**
 上传数据

 @param param 参数
 @param showHud 是否显示加载动画
 @param constructingBodyWithBlock 传入数据
 @param process 进程
 @param success 请求成功回调
 @param failure 请求失败回调

 @return NSURLSessionDataTask任务对象
 */
- (NSURLSessionDataTask *)upload:(ZYBaseParam *)param
                         showHUD:(BOOL)showHud
       constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constructingBodyWithBlock
                        progress:(void (^)(NSProgress * uploadProgress))process
                         success:(void (^)(NSURLSessionDataTask *task, ZYHttpResponse *responseObj))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                        authFail:(void (^)(void))authFail;

@end
