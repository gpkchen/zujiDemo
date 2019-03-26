//
//  SilenceLogin.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**静默登录参数*/
@interface _p_SilenceLogin : ZYBaseParam

/**刷新令牌*/
@property (nonatomic , copy) NSString *refreshToken;

@end




/**静默登录返回*/
@interface _m_SilenceLogin : ZYBaseModel

/**接口请求令牌*/
@property (nonatomic , copy) NSString *apiToken;
/**头像*/
@property (nonatomic , copy) NSString *avatar;

@end
