//
//  FavoriteDelete.h
//  Apollo
//
//  Created by shaxia on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"
/**删除收藏参数*/
@interface _p_FavoriteDelete : ZYBaseParam
/**宝贝id*/
@property (nonatomic , copy) NSArray *itemIds;

@end

/**删除收藏返回*/
@interface _m_FavoriteDelete : ZYBaseModel

@end
