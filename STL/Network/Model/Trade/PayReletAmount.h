//
//  PayReletAmount.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**续租参数*/
@interface _p_PayReletAmount : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**优惠券id*/
@property (nonatomic , copy) NSString *couponId;
/**租期(数字)*/
@property (nonatomic , copy) NSString *rentPeriod;
/**支付渠道*/
@property (nonatomic , copy) NSString *payChannel;

@end
