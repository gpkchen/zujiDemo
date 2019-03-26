//
//  ZYQuotaService.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**免押额度服务*/
@interface ZYQuotaService : NSObject

/**发起运营商认证*/
+ (void)authOperator;

/**发起淘宝认证*/
+ (void)authTaobao:(BOOL)shouldStartAuth;

/**发起学生认证*/
+ (void)authStudent;

/**发起授信 flag:是否保存信息标志（在获取免押额度时传1，其他不传）*/
+ (void)startAuthing:(NSString *)flag success:(void(^)(void))success;

@end
