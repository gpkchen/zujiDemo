//
//  PayPenaltyAmount.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**支付违约金参数*/
@interface _p_PayPenaltyAmount : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**支付渠道*/
@property (nonatomic , copy) NSString *payChannel;
/**优惠券id*/
@property (nonatomic , copy) NSString *couponId;

@end

