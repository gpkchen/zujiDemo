//
//  ZYEnvirUtils.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/13.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ZYBuildEnvirKey;

typedef NS_ENUM(int , ZYEnvir) {
    ZYEnvirDev = 1, //开发环境
    ZYEnvirTest = 2, //测试环境
    ZYEnvirGray = 3, //灰度环境
    ZYEnvirPublish = 4, //生产环境
};

@interface ZYEnvirUtils : NSObject

/**单例*/
+ (instancetype) utils;

/**环境*/
@property (nonatomic , assign , readonly) ZYEnvir envir;
/**协议加密秘钥*/
@property (nonatomic , copy , readonly) NSString *protocolEncodeKey;
/**H5地址前缀*/
@property (nonatomic , copy , readonly) NSString *h5Prefix;
/**web地址前缀*/
@property (nonatomic , copy , readonly) NSString *webPrefix;
/**接口请求地址*/
@property (nonatomic , copy , readonly) NSString *apiUrl;
/**认证回调*/
@property (nonatomic , copy , readonly) NSString *authCallBackUrl;

@end
