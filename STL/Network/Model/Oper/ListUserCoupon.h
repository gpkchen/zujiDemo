//
//  ListUserCoupon.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**优惠券列表查询参数*/
@interface _p_ListUserCoupon : ZYBaseParam

/**0-未使用 1-已使用 2-已过期 3-已使用和已过期*/
@property (nonatomic , copy) NSString *status;
/**页码*/
@property (nonatomic , copy) NSString *page;
/**页面大小*/
@property (nonatomic , copy) NSString *size;

@end






/**优惠券列表查询返回*/
@interface _m_ListUserCoupon : ZYBaseModel

/**优惠券id*/
@property (nonatomic , copy) NSString *couponId;
/**优惠券类型*/
@property (nonatomic , copy) NSString *type;
/**优惠券类型（枚举值）0-现金抵扣券,3-满减券，4-折扣券*/
@property (nonatomic , assign) int couponType;
/**优惠券面额*/
@property (nonatomic , assign) double amount;
/**折扣*/
@property (nonatomic , assign) double discount;
/**适用商品*/
@property (nonatomic , copy) NSString *useScene;
/**适用场景*/
@property (nonatomic , copy) NSString *useRange;
/**使用规则*/
@property (nonatomic , copy) NSString *rule;
/**有效期*/
@property (nonatomic , copy) NSString *effectiveTime;
/**是否已经领取*/
@property (nonatomic , assign) BOOL receiveFlag;
/**是否已经领完*/
@property (nonatomic , assign) BOOL receiveFinishedFlag;
/**能否使用*/
@property (nonatomic , assign) BOOL useFlag;
/**发放任务id*/
@property (nonatomic , copy) NSString *couponGrantId;
/**失效类型 1-已过期 2-已使用*/
@property (nonatomic , assign) int invitedId;


/**本地：可优惠的金额*/
@property (nonatomic , assign) double countDiscount;
/**本地：活动优惠金额*/
@property (nonatomic , assign) double activityDiscount;
/**本地：是否可展开*/
@property (nonatomic , assign) BOOL openable;
/**本地：是否已展开*/
@property (nonatomic , assign) BOOL isOpen;
/**本地：cell正常高度*/
@property (nonatomic , assign) CGFloat cellNormalHeight;
/**本地：cell展开高度*/
@property (nonatomic , assign) CGFloat cellOpenHeight;

@end
