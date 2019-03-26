//
//  GetReletPeriod.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**租期查询参数*/
@interface _p_GetReletPeriod : ZYBaseParam

@property (nonatomic , copy) NSString *rentType;

@end



/**租期查询返回*/
@interface _m_GetReletPeriod : ZYBaseModel

/**租期*/
@property (nonatomic , assign) int rentPeriod;

@end
