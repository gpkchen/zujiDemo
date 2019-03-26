//
//  ZYHttpClient.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYHttpClient.h"
#import <UIKit/UIKit.h>
#import "ZYHttpTask.h"
#import "C.h"
#import "SilenceLogin.h"
#import "DeviceReceive.h"

NSString * const ZYRequestDefaultPageSize = @"15";
NSString * const ZYHttpErrorMessageNoNet = @"网络断了，找不到机有了";
NSString * const ZYHttpErrorMessageNetTimeOut = @"等会再来吧，数据加载不到啦";
NSString * const ZYHttpErrorMessageSystemError = @"服务器崩溃了T-T";

NSString * const ZYNetworkReachabilityStatusChangedNotification = @"ZYNetworkReachabilityStatusChangedNotification";

static NSString * const kUploadDeviceInfoKey = @"kUploadDeviceInfoKey";

@interface ZYHttpClient ()

//afnetworking管理对象
@property (nonatomic , strong) AFHTTPSessionManager *manager;
//网络连接
@property (nonatomic , assign) AFNetworkReachabilityStatus reachabilityStatus;

//验签排序方式
@property (nonatomic , copy) NSString *s;
//签名加密的SecurityKey
@property (nonatomic , copy) NSString *k;

//是否正在获取验签规则
@property (nonatomic , assign) BOOL isLoadingSignRule;
//验签失败等待队列
@property (nonatomic , strong) NSMutableArray *signFailWaitQueue;

//是否正在刷新token
@property (nonatomic , assign) BOOL isRefreshingToken;
//token失效等待队列
@property (nonatomic , strong) NSMutableArray *apiTokenFailWaitQueue;

@end

@implementation ZYHttpClient

+ (instancetype)client{
    static ZYHttpClient *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYHttpClient alloc] init];
    });
    
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if(self){
        _isLoadingSignRule = NO;
        _isRefreshingToken = NO;
        [self networkMonitor];
    }
    return self;
}

#pragma mark - public
- (void)loadSignRule:(BOOL)showHud{
    _isLoadingSignRule = YES;
    _p_C *param = [_p_C new];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                NSString *c = responseObj.data[@"c"];
                                if(c.length >= 50){
                                    NSString *key = [c substringWithRange:NSMakeRange(10, 40)];
                                    NSString *encode1 = [c substringToIndex:10];
                                    NSString *encode2 = [c substringFromIndex:50];
                                    NSString *encode = [encode1 stringByAppendingString:encode2];
                                    NSString *decode = [encode tripleDES:kCCDecrypt key:key];
                                    NSDictionary *dic = [decode dict];
                                    self.s = dic[@"s"];
                                    self.k = dic[@"k"];
                                    
                                    self.isLoadingSignRule = NO;
                                    //开始处理挂起的请求任务
                                    [self releaseSignErrorTasks];
                                }
                            }else{
                                self.isLoadingSignRule = NO;
                                [self deleteSignQueue];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            self.isLoadingSignRule = NO;
                            [self deleteSignQueue];
                        } authFail:nil];
}

- (void)refreshApiToken:(BOOL)showHud{
    _isRefreshingToken = YES;
    [[ZYLoginService service] tokenLogin:showHud complete:^(BOOL success){
        if(success){
            self.isRefreshingToken = NO;
            //处理挂起的请求任务
            [self releaseApiTokenErrorTasks];
        }else{
            //token认证失败通知
            [[NSNotificationCenter defaultCenter] postNotificationName:ZYTokenAuthFailNotification object:nil];
            [[ZYRouter router] goWithoutHead:@"login" withCallBack:^(BOOL isCancel){
                 if(!isCancel){
                     self.isRefreshingToken = NO;
                     //处理挂起的请求任务
                     [self releaseApiTokenErrorTasks];
                 }else{
                     for(ZYHttpTask *task in self.apiTokenFailWaitQueue){
                         !task.authFail ? : task.authFail();
                     }
                     [[ZYRouter router] returnToRoot];
                     self.isRefreshingToken = NO;
                     [self deleteTokenQueue];
                 }
             }];
        }
     }];
}

- (void)uploadDeviceInfo{
    NSString *key = [NSUserDefaults readObjectWithKey:kUploadDeviceInfoKey];
    if(key && [kUploadDeviceInfoKey isEqualToString:key]){
        return;
    }
    _p_DeviceReceive *param = [_p_DeviceReceive new];
    [self post:param
       showHud:NO
       success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
           if(responseObj.isSuccess){
               [NSUserDefaults writeWithObject:kUploadDeviceInfoKey forKey:kUploadDeviceInfoKey];
           }
       } failure:nil authFail:nil];
}

- (NSURLSessionDataTask *)post:(ZYBaseParam *)param
                       showHud:(BOOL)showHud
                       success:(void (^)(NSURLSessionDataTask *task, ZYHttpResponse *responseObj))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                      authFail:(void (^)(void))authFail{
#ifndef DEBUG
    if([self fetchHttpProxy]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请关闭网络代理！"
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil
                                                    clickAction:nil];
        [alert show];
        return nil;
    }
#endif
    //正在加载验签规则时将请求任务挂起
    if(_isLoadingSignRule && ![param isKindOfClass:[_p_C class]]){
        ZYHttpTask *httpTask = [ZYHttpTask new];
        httpTask.showHud = showHud;
        httpTask.success = success;
        httpTask.failure = failure;
        httpTask.param = param;
        [self.signFailWaitQueue addObject:httpTask];
        return nil;
    }
    //正在刷新token时将请求任务挂起
    if(_isRefreshingToken && param.needApiToekn){
        ZYHttpTask *httpTask = [ZYHttpTask new];
        httpTask.showHud = showHud;
        httpTask.success = success;
        httpTask.failure = failure;
        httpTask.param = param;
        [self.apiTokenFailWaitQueue addObject:httpTask];
        return nil;
    }
    [self.manager.requestSerializer setValue:param.timestamp forHTTPHeaderField:@"timestamp"];
    [self.manager.requestSerializer setValue:[ZYDeviceUtils utils].uuidForDevice forHTTPHeaderField:@"deviceID"];
    [self.manager.requestSerializer setValue:APP_BUILD forHTTPHeaderField:@"appVersion"];
    [self.manager.requestSerializer setValue:param.apiVersion forHTTPHeaderField:@"apiVersion"];
    [self.manager.requestSerializer setValue:RequestClient forHTTPHeaderField:@"client"];
    if([ZYUser user].userId){ 
        [self.manager.requestSerializer setValue:[ZYUser user].userId forHTTPHeaderField:@"uid"];
    }else{
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"uid"];
    }
    if([ZYUser user].apiToken){
        [self.manager.requestSerializer setValue:[ZYUser user].apiToken forHTTPHeaderField:@"apiToken"];
    }else{
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"apiToken"];
    }
    if(_k && _s){
        [self.manager.requestSerializer setValue:[param countSign:_s k:_k] forHTTPHeaderField:@"sign"];
    }
    ZYLog(@"_________________POSTing:%@",param.url);
    ZYHud *hud = nil;
    if(showHud){
        hud = [ZYHud new];
        [hud show];
    }
    NSURLSessionDataTask *task = [self.manager POST:param.url
                                         parameters:[param getDicParam]
                                           progress:nil
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                  {
                                      ZYLog(@"_________________POSTed:%@->%@",param.url,responseObject);
                                      if(showHud){
                                          [hud dismiss];
                                      }
                                      ZYHttpResponse *response = [[ZYHttpResponse alloc] initWithDictionary:responseObject];
                                      if(response.code == ZYHttpResponseCodeSignError && ![param isKindOfClass:[_p_C class]]){
                                          //收到验签错误，将请求暂存等待队列
                                          ZYHttpTask *httpTask = [ZYHttpTask new];
                                          httpTask.success = success;
                                          httpTask.showHud = showHud;
                                          httpTask.failure = failure;
                                          httpTask.param = param;
                                          httpTask.authFail = authFail;
                                          [self.signFailWaitQueue addObject:httpTask];
                                          if(!self.isLoadingSignRule){
                                              [self loadSignRule:showHud];
                                          }
                                      }else if(response.code == ZYHttpResponseCodeTokenError && ![param isKindOfClass:[_p_SilenceLogin class]]){
                                          //收到Token错误，将请求暂存等待队列
                                          ZYHttpTask *httpTask = [ZYHttpTask new];
                                          httpTask.success = success;
                                          httpTask.showHud = showHud;
                                          httpTask.failure = failure;
                                          httpTask.param = param;
                                          httpTask.authFail = authFail;
                                          [self.apiTokenFailWaitQueue addObject:httpTask];
                                          if(!self.isRefreshingToken){
                                              [self refreshApiToken:showHud];
                                          }
                                      }else{
                                          !success ? : success(task,response);
                                      }
                                  }
                                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                  {
                                      ZYLog(@"_________________POSTed:%@->Fail",param.url);
                                      if(showHud){
                                          [hud dismiss];
                                      }
                                      !failure ? : failure(task,error);
                                  }];
    
    return task;
}

- (NSURLSessionDataTask *)upload:(ZYBaseParam *)param
                         showHUD:(BOOL)showHud
       constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constructingBodyWithBlock
                        progress:(void (^)(NSProgress * uploadProgress))process
                         success:(void (^)(NSURLSessionDataTask *task, ZYHttpResponse *responseObj))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                        authFail:(void (^)(void))authFail
{
#ifndef DEBUG
    if([self fetchHttpProxy]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请关闭网络代理！"
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil
                                                    clickAction:nil];
        [alert show];
        return nil;
    }
#endif
    [self.manager.requestSerializer setValue:param.timestamp forHTTPHeaderField:@"timestamp"];
    [self.manager.requestSerializer setValue:[ZYDeviceUtils utils].uuidForDevice forHTTPHeaderField:@"deviceID"];
    [self.manager.requestSerializer setValue:APP_BUILD forHTTPHeaderField:@"appVersion"];
    [self.manager.requestSerializer setValue:ApiVersion forHTTPHeaderField:@"apiVersion"];
    [self.manager.requestSerializer setValue:RequestClient forHTTPHeaderField:@"client"];
    if([ZYUser user].userId){
        [self.manager.requestSerializer setValue:[ZYUser user].userId forHTTPHeaderField:@"uid"];
    }else{
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"uid"];
    }
    if([ZYUser user].apiToken){
        [self.manager.requestSerializer setValue:[ZYUser user].apiToken forHTTPHeaderField:@"apiToken"];
    }else{
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"apiToken"];
    }
    if(_k && _s){
        [self.manager.requestSerializer setValue:[param countSign:_s k:_k] forHTTPHeaderField:@"sign"];
    }
    ZYLog(@"_________________POSTing:%@",param.url);
    ZYHud *hud = nil;
    if(showHud){
        hud = [ZYHud new];
        [hud show];
    }

    NSURLSessionDataTask *task = [self.manager POST:param.url ? param.url : @"" parameters:[param getDicParam] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        !constructingBodyWithBlock ? : constructingBodyWithBlock(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        !process ? : process(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZYLog(@"_________________POSTed:%@->%@",param.url,responseObject);
        if(showHud){
            [hud dismiss];
        }
        ZYHttpResponse *response = [[ZYHttpResponse alloc] initWithDictionary:responseObject];
        !success ? : success(task,response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZYLog(@"_________________POSTed:%@->Fail",param.url);
        if(showHud){
            [hud dismiss];
        }
        !failure ? : failure(task,error);
    }];
    return task;
    
}

#pragma mark - 处理等待验签挂起任务
- (void)releaseSignErrorTasks{
    NSMutableArray *tks = [self.signFailWaitQueue mutableCopy];
    [self.signFailWaitQueue removeAllObjects];
    [tks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZYHttpTask *tk = obj;
        [self post:tk.param
           showHud:tk.showHud
           success:tk.success
           failure:tk.failure
          authFail:tk.authFail];
    }];
}

#pragma mark - 处理等待apiToken挂起任务
- (void)releaseApiTokenErrorTasks{
    NSMutableArray *tks = [self.apiTokenFailWaitQueue mutableCopy];
    [self.apiTokenFailWaitQueue removeAllObjects];
    [tks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZYHttpTask *tk = obj;
        [self post:tk.param
           showHud:tk.showHud
           success:tk.success
           failure:tk.failure
          authFail:tk.authFail];
    }];
}

#pragma mark - 释放验签等待队列
- (void)deleteSignQueue{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"sign refresh fail" forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"com.zy.apollo.sign" code:ZYHttpErrorCodeSystemError userInfo:userInfo];
    for(ZYHttpTask *httpTask in self.signFailWaitQueue){
        !httpTask.failure ? : httpTask.failure(nil,error);
    }
    [self.signFailWaitQueue removeAllObjects];
}

#pragma mark - 释放令牌等待队列
- (void)deleteTokenQueue{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"api token refresh fail" forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"com.zy.apollo.apitoken" code:ZYHttpErrorCodeTokenError userInfo:userInfo];
    for(ZYHttpTask *httpTask in self.apiTokenFailWaitQueue){
        !httpTask.failure ? : httpTask.failure(nil,error);
    }
    [self.apiTokenFailWaitQueue removeAllObjects];
}

#pragma mark - 检测网络代理
- (NSString *)fetchHttpProxy {
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dicRef,
                                                                           (const void*)kCFNetworkProxiesHTTPProxy);
    NSString *proxy = (__bridge NSString *)proxyCFstr;
    return  proxy;
}

#pragma mark - 网络连接监听
- (void)networkMonitor{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        self.reachabilityStatus = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYNetworkReachabilityStatusChangedNotification object:nil];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"网络连接不可用！请检查网络状态！"
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil
                                                            clickAction:nil];
                [alert show];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                
            }
                break;
            default:
                break;
        }
        if(status != AFNetworkReachabilityStatusNotReachable){
            [self uploadDeviceInfo];
        }
    }];
}

#pragma mark - getter
- (AFHTTPSessionManager *)manager{
    if(!_manager){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10.0f;
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[ZYEnvirUtils utils].apiUrl]
                                            sessionConfiguration:configuration];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _manager.requestSerializer.timeoutInterval = 10.f;
        [_manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        
//#ifdef Archive_Release
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = NO;
//        //validatesDomainName 是否需要验证域名，默认为YES；
//        securityPolicy.validatesDomainName = YES;
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"apollo" ofType:@"cer"];//证书的路径
//        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//        securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
//
//        _manager.securityPolicy  = securityPolicy;
//#else
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//#endif
    }
    return _manager;
}

#pragma mark - getter
- (NSMutableArray *)signFailWaitQueue{
    if(!_signFailWaitQueue){
        _signFailWaitQueue = [NSMutableArray array];
    }
    return _signFailWaitQueue;
}

- (NSMutableArray *)apiTokenFailWaitQueue{
    if(!_apiTokenFailWaitQueue){
        _apiTokenFailWaitQueue = [NSMutableArray array];
    }
    return _apiTokenFailWaitQueue;
}

@end
