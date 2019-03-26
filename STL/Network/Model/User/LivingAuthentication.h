//
//  LivingAuthentication.h
//  Apollo
//
//  Created by shaxia on 2018/5/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**发起活体认证参数*/
@interface _p_LivingAuthentication : ZYBaseParam

@end

/**发起活体认证返回*/
@interface _m_LivingAuthentication : ZYBaseModel

/**活体认证地址*/
@property (nonatomic , strong) NSString *url;

@end
