//
//  PayBuyOffAmount.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**发起买断请求参数*/
@interface _p_PayBuyOffAmount : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**支付类型 21:支付宝 11：微信*/
@property (nonatomic , copy) NSString *payType;
/**优惠券id*/
@property (nonatomic , copy) NSString *couponId;

@end







/**发起买断请求返回*/
@interface _m_PayBuyOffAmount : ZYBaseModel

@property (nonatomic , copy) NSString *orderInfo;

@end
