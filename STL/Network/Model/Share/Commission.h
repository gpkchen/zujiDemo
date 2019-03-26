//
//  Commission.h
//  Apollo
//
//  Created by shaxia on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**赚佣金参数*/
@interface _p_Commission : ZYBaseParam

@end

/**赚佣金返回*/
@interface _m_Commission : ZYBaseModel

/**邀请好友*/
@property (nonatomic , copy) NSString *invitation;

/**累计现金优惠券*/
@property (nonatomic , copy) NSString *cashCoupon;

/**滚动列表*/
@property (nonatomic , copy) NSArray    *rollerList;

@end


/**赚佣金返回*/
@interface _m_Commission_rollerList : ZYBaseModel

/**手机号*/
@property (nonatomic , copy) NSString *mobile;

/**面额*/
@property (nonatomic , copy) NSString *denomination;

/**类型*/
@property (nonatomic , copy) NSString *rewardType;


@end

