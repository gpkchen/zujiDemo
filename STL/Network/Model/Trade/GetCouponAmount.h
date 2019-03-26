//
//  GetCouponAmount.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**支付根据优惠券计算价格参数*/
@interface _p_GetCouponAmount : ZYBaseParam

/**使用场景 0-首期账单 1-分期账单 2-买断 3-续租*/
@property (nonatomic , copy) NSString *scene;
/**商品id，下单使用*/
@property (nonatomic , copy) NSString *itemId;
/**商品类目id，下单使用*/
@property (nonatomic , copy) NSString *categoryId;
/**价格id，下单使用*/
@property (nonatomic , copy) NSString *priceId;
/**增值服务id列表逗号隔开，下单使用*/
@property (nonatomic , copy) NSString *serviceIds;
/**账单id集合逗号隔开，支付账单使用*/
@property (nonatomic , copy) NSString *billIds;
/**账单付款类型 1：单笔账单 2：全部剩余账单，支付账单使用*/
@property (nonatomic , copy) NSString *billPayType;
/**订单id，续租使用*/
@property (nonatomic , copy) NSString *orderId;
/**续租期数，续租使用*/
@property (nonatomic , copy) NSString *rentPeriod;
/**优惠券id*/
@property (nonatomic , copy) NSString *couponId;

@end



/**支付根据优惠券计算价格返回*/
@interface _m_GetCouponAmount : ZYBaseParam

/**可优惠金额*/
@property (nonatomic , assign) double amount;

@end
