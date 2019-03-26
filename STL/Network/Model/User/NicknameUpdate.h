//
//  NicknameUpdate.h
//  Apollo
//
//  Created by shaxia on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

@interface _p_NicknameUpdate : ZYBaseParam

/**用户Id*/
@property (nonatomic , copy) NSString *userId;

/**用户昵称*/
@property (nonatomic , copy) NSString *nickname;

@end

@interface _m_NicknameUpdate : ZYBaseParam

@end
