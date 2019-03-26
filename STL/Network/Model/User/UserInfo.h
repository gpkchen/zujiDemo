//
//  UserInfo.h
//  Apollo
//
//  Created by shaxia on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**获取用户详情参数*/
@interface _p_UserInfo : ZYBaseParam

@end

/**获取用户详情返回*/
@interface _m_UserInfo : ZYBaseModel

/**用户头像路径*/
@property (nonatomic , copy) NSString *portraitPath;

/**用户名称*/
@property (nonatomic , copy) NSString *nickname;

@end
