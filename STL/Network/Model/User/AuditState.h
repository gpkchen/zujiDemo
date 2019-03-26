//
//  AuditState.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**获取用户单独授权信息参数*/
@interface _p_AuditState : ZYBaseParam

@end



/**获取用户单独授权信息返回*/
@interface _m_AuditState : ZYBaseModel

/**授信状态*/
@property (nonatomic , assign) ZYAuthState status;

@end
