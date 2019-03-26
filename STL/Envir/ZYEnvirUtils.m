//
//  ZYEnvirUtils.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/13.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYEnvirUtils.h"

NSString * const ZYBuildEnvirKey = @"kBuildEnvirKey";

@implementation ZYEnvirUtils

@synthesize envir = _envir;
@synthesize protocolEncodeKey = _protocolEncodeKey;
@synthesize h5Prefix = _h5Prefix;
@synthesize webPrefix = _webPrefix;
@synthesize apiUrl = _apiUrl;
@synthesize authCallBackUrl = _authCallBackUrl;

+ (instancetype) utils{
    static ZYEnvirUtils *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYEnvirUtils alloc] init];
    });
    
    return _instance;
}

#pragma mark - getter
- (ZYEnvir)envir{
    if(!_envir){
#ifdef Archive_Develope
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Publish" isEqualToString:key]){
            //生产
            _envir = ZYEnvirPublish;
        }else if([@"EN_Gray" isEqualToString:key]){
            //灰度
            _envir = ZYEnvirGray;
        }else if([@"EN_Test" isEqualToString:key]){
            //测试
            _envir = ZYEnvirTest;
        }else{
            //开发、默认
            _envir = ZYEnvirDev;
        }
#else
        _envir = ZYEnvirPublish;
#endif
    }
    return _envir;
}

- (NSString *)protocolEncodeKey{
    if(!_protocolEncodeKey){
#ifdef Archive_Develope
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Publish" isEqualToString:key] || [@"EN_Gray" isEqualToString:key]){
            //生产、灰度
            _protocolEncodeKey = @"8ed16f386e57b355898b1640389e6d851fa06303";
        }else{
            //开发、测试、默认
            _protocolEncodeKey = @"asunf65eb571g56f03bbbbbb660eaee4fbc39294";
        }
#else
    _protocolEncodeKey = @"8ed16f386e57b355898b1640389e6d851fa06303";
#endif
    }
    return _protocolEncodeKey;
}

- (NSString *)h5Prefix{
    if(!_h5Prefix){
#ifdef Archive_Develope
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Publish" isEqualToString:key]){
            //生产
            _h5Prefix = @"https://m.jiyou666.cn/app/#/main/";
        }else if([@"EN_Gray" isEqualToString:key]){
            //灰度
            _h5Prefix = @"https://ym.jiyou666.cn/app/#/main/";
        }else if([@"EN_Test" isEqualToString:key]){
            //测试
            _h5Prefix = @"http://tm.jiyou666.cn:10009/app/#/main/";
        }else{
            //开发、默认
            _h5Prefix = @"http://dm.jiyou666.cn:20010/app/#/main/";
        }
#else
        _h5Prefix = @"https://m.jiyou666.cn/app/#/main/";
#endif
    }
    return _h5Prefix;
}

- (NSString *)webPrefix{
    if(!_webPrefix){
#ifdef Archive_Develope
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Publish" isEqualToString:key]){
            //生产
            _webPrefix = @"https://m.jiyou666.cn/wap/#/main/";
        }else if([@"EN_Gray" isEqualToString:key]){
            //灰度
            _webPrefix = @"https://ym.jiyou666.cn/wap/#/main/";
        }else if([@"EN_Test" isEqualToString:key]){
            //测试
            _webPrefix = @"http://tm.jiyou666.cn:10009/wap/#/main/";
        }else{
            //开发、默认
            _webPrefix = @"http://dm.jiyou666.cn:20010/wap/#/main/";
        }
#else
        _webPrefix = @"https://m.jiyou666.cn/wap/#/main/";
#endif
    }
    return _webPrefix;
}

- (NSString *)apiUrl{
    if(!_apiUrl){
#ifdef Archive_Develope
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Publish" isEqualToString:key]){
            //生产
            _apiUrl = @"https://rest.jiyou666.cn";
        }else if([@"EN_Gray" isEqualToString:key]){
            //灰度
            _apiUrl = @"https://yrest.jiyou666.cn";
        }else if([@"EN_Test" isEqualToString:key]){
            //测试
            _apiUrl = @"http://trest.jiyou666.cn:10009";
        }else{
            //开发、默认
            _apiUrl = @"http://drest.jiyou666.cn:20010";
        }
#else
        _apiUrl = @"https://rest.jiyou666.cn";
#endif
    }
    ZYLog(@">>>>>>>>>>>>>>选择api:%@",_apiUrl);
    return _apiUrl;
}

- (NSString *)authCallBackUrl{
    if(!_authCallBackUrl){
#ifdef Archive_Develope
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Publish" isEqualToString:key]){
            //生产
            _authCallBackUrl = @"https://api.jiyou666.cn/user";
        }else if([@"EN_Gray" isEqualToString:key]){
            //灰度
            _authCallBackUrl = @"https://yapi.jiyou666.cn/user";
        }else if([@"EN_Test" isEqualToString:key]){
            //测试
            _authCallBackUrl = @"http://tapi.jiyou666.cn:10009/user";
        }else{
            //开发、默认
            _authCallBackUrl = @"http://dapi.jiyou666.cn:20010/user";
        }
#else
        _authCallBackUrl = @"https://api.jiyou666.cn/user";
#endif
    }
    return _authCallBackUrl;
}

@end
