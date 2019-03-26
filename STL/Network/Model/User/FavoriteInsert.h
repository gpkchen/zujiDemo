//
//  FavoriteInsert.h
//  Apollo
//
//  Created by shaxia on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**添加收藏参数*/
@interface _p_FavoriteInsert : ZYBaseParam

/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;

@end

/**添加收藏返回*/
@interface _m_FavoriteInsert : ZYBaseModel

@end
