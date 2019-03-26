//
//  PayBills.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**支付账单参数*/
@interface _p_PayBills : ZYBaseParam

/**订单ID*/
@property (nonatomic , copy) NSString *orderId;
/**账单ID 付清剩余账单时候中间用逗号分隔账单ID*/
@property (nonatomic , copy) NSString *billIds;
/**支付方式 21支付宝 11微信*/
@property (nonatomic , copy) NSString *payType;
/**账单付款类型 1：单笔账单 2：全部剩余账单*/
@property (nonatomic , copy) NSString *billPayType;
/**优惠券ID*/
@property (nonatomic , copy) NSString *couponId;

@end
