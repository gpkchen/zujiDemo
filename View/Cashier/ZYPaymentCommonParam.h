//
//  ZYPaymentCommonParam.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**支付目的*/
typedef NS_ENUM(int , ZYPaymentTarget) {
    ZYPaymentTargetBill = 1, //支付订单
    ZYPaymentTargetBuy = 2, //支付买断
    ZYPaymentTargetRenewal = 3, //支付续租
    ZYPaymentTargetPenalty = 4, //支付违约金
};

@interface ZYPaymentCommonParam : NSObject

/**支付目的*/
@property (nonatomic , assign) ZYPaymentTarget target;
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
/**租期(数字)*/
@property (nonatomic , copy) NSString *rentPeriod;

@end
