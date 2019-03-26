//
//  Login.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**手机号登录参数*/
@interface _p_Login : ZYBaseParam

/**手机号*/
@property (nonatomic , copy) NSString *mobile;
/**验证码*/
@property (nonatomic , copy) NSString *code;
/**纬度*/
@property (nonatomic , copy) NSString *latitude;
/**经度*/
@property (nonatomic , copy) NSString *longitude;
/**渠道*/
@property (nonatomic , copy) NSString *channel;

@end



/**手机号登录返回*/
@interface _m_Login : ZYBaseModel

/**用户id*/
@property (nonatomic , copy) NSString *userId;
/**接口请求令牌*/
@property (nonatomic , copy) NSString *apiToken;
/**刷新令牌*/
@property (nonatomic , copy) NSString *refreshToken;
/**用户状态*/
@property (nonatomic , copy) NSString *state;
/**头像*/
@property (nonatomic , copy) NSString *avatar;

@end
