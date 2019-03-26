//
//  UserIdCard.h
//  Apollo
//
//  Created by shaxia on 2018/5/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**用户idCard查询参数*/
@interface _p_UserIdCard : ZYBaseParam

@end

/**用户idCard查询返回*/
@interface _m_UserIdCard : ZYBaseModel

/**用户名*/
@property (nonatomic , copy) NSString *userName;

/**用户身份证号*/
@property (nonatomic , copy) NSString *idCard;

@end
