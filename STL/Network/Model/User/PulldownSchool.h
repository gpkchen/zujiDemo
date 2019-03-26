//
//  PulldownSchool.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**学校模糊查询参数*/
@interface _p_PulldownSchool : ZYBaseParam

/**模糊学校名称*/
@property (nonatomic , copy) NSString *str;

@end





/**学校模糊查询返回*/
@interface _m_PulldownSchool : ZYBaseModel

/**学校编号*/
@property (nonatomic , copy) NSString *schoolId;
/**学校名*/
@property (nonatomic , copy) NSString *schoolName;

@end
