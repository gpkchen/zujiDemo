//
//  AliPayCallback.h
//  Apollo
//
//  Created by shaxia on 2018/5/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**查询芝麻分参数*/
@interface _p_AliPayCallback : ZYBaseParam

@property (nonatomic , strong) NSString *authCode;

@end

/**查询芝麻分返回*/
@interface _m_AliPayCallback : ZYBaseModel

@end
