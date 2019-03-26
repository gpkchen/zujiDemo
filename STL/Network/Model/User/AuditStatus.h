//
//  AuditStatus.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**获取用户全量授权信息参数*/
@interface _p_AuditStatus : ZYBaseParam

@end





/**获取用户全量授权信息返回*/
@interface _m_AuditStatus : ZYBaseModel

/**授信状态*/
@property (nonatomic , assign) ZYAuthState status;
/**可用额度*/
@property (nonatomic , assign) double limit;
/**总额度*/
@property (nonatomic , assign) double totalLimit;
/**已用额度*/
@property (nonatomic , assign) double useLimit;
/**运营商是否已认证*/
@property (nonatomic , assign) BOOL writeOperator;
/**淘宝开关*/
@property (nonatomic , assign) BOOL taoBaoSwitch;
/**淘宝是否已认证*/
@property (nonatomic , assign) BOOL writeTaobao;
/**学生证是否已认证*/
@property (nonatomic , assign) BOOL studentIdCard;
/**是否有临时额度*/
@property (nonatomic , assign) BOOL tempLimitFlag;
/**临时额度*/
@property (nonatomic , assign) double tempLimit;
/**临时额度有效期*/
@property (nonatomic , copy) NSString *tempLimitEffective;
/**临时额度说明*/
@property (nonatomic , copy) NSString *tempLimitExplain;

@end
