//
//  PortraitUpdate.h
//  Apollo
//
//  Created by shaxia on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**用户修改头像参数*/
@interface _p_PortraitUpdate : ZYBaseParam

/**用户头像路径*/
@property (nonatomic , copy) NSString *portraitPath;

@end

@interface _m_PortraitUpdate : ZYBaseModel

@end
