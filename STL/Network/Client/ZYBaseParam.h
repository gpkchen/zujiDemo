//
//  ZYBaseParam.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**http请求参数基类*/
@interface ZYBaseParam : NSObject

/**header:时间戳*/
@property (nonatomic , copy) NSString *timestamp;
/**api地址*/
@property (nonatomic , copy) NSString *url;
/**api版本号*/
@property (nonatomic , copy) NSString *apiVersion;
/**是否需要验证apitoken,默认yes*/
@property (nonatomic , assign) BOOL needApiToekn;

/**获取网络请求参数字典对象*/
- (NSDictionary *)getDicParam;
/**计算签名*/
- (NSString *)countSign:(NSString *)s k:(NSString *)k;

@end
