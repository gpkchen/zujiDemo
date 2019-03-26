//
//  LivingCallback.h
//  Apollo
//
//  Created by shaxia on 2018/5/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

@class _p_LivingCallback_content;
/**查询活体认证参数*/
@interface _p_LivingCallback : ZYBaseParam

@property (nonatomic , copy) NSDictionary *biz_content;

@property (nonatomic , copy) NSString *sign;

@end

/**查询活体认证返回*/
@interface _m_LivingCallback : ZYBaseModel

@end
