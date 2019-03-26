//
//  ReceiveList.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/29.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**用户自领优惠券列表查询参数*/
@interface _p_ReceiveList : ZYBaseParam

/**类目id*/
@property (nonatomic , copy) NSString *categoryId;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;

@end

NS_ASSUME_NONNULL_END
