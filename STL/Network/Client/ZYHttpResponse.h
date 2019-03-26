//
//  ZYHttpResponse.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>


/**接口请求返回码*/
typedef NS_ENUM(int,ZYHttpResponseCode) {
    ZYHttpResponseCodeSuccess = 200,//请求成功
    ZYHttpResponseCodeSignError = 1001,//验签错误
    ZYHttpResponseCodeTokenError = 1002,//token失效
    ZYHttpResponseCodeBusinessError = 3000,//业务错误
};



/**http返回*/
@interface ZYHttpResponse : NSObject

/**是否请求成功*/
@property (nonatomic , assign , getter=isSuccess) BOOL success;
/**错误码*/
@property (nonatomic , assign) int code;
/**错误消息*/
@property (nonatomic , copy) NSString *message;
/**业务数据*/
@property (nonatomic , strong) id data;

/**便利构造器*/
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
