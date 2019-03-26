//
//  GetOrderDetail.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**订单详情查询参数*/
@interface _p_GetOrderDetail : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;

@end





/**订单详情查询返回*/
@interface _m_GetOrderDetail : ZYBaseModel

/**客服电话*/
@property (nonatomic , copy) NSString *servicePhone;
/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**宝贝图片*/
@property (nonatomic , copy) NSString *imageUrl;
/**规格*/
@property (nonatomic , copy) NSString *goodsSkuNames;
/**租金*/
@property (nonatomic , copy) NSString *rentPrice;
/**订单状态*/
@property (nonatomic , assign) ZYOrderState status;
/**下单时间*/
@property (nonatomic , copy) NSString *orderTime;
/**支付过期时间*/
@property (nonatomic , assign) long long payExpireTime;
/**距离账单日天数*/
@property (nonatomic , assign) int repayBillDays;
/**逾期天数*/
@property (nonatomic , assign) int overdueDays;
/**距离归还日天数*/
@property (nonatomic , assign) int returnBackDays;
/**距离归还日天数（不计算推延）*/
@property (nonatomic , assign) int realReturnBackDays;
/**账单是否已还清*/
@property (nonatomic , assign) BOOL isPayAllBills;
/**收货人名称*/
@property (nonatomic , copy) NSString *reciveContact;
/**收货电话*/
@property (nonatomic , copy) NSString *reciveMobile;
/**收货地址*/
@property (nonatomic , copy) NSString *reciveAddress;
/**总押金*/
@property (nonatomic , assign) double deposit;
/**邮寄方式*/
@property (nonatomic , assign) ZYExpressType expressType;
/**需要支付押金*/
@property (nonatomic , assign) double needPayDeposit;
/**减免押金（额度）*/
@property (nonatomic , assign) double orderLimit;
/**租期类型*/
@property (nonatomic , assign) ZYRentType rentType;
/**租金*/
@property (nonatomic , assign) double monthPay;
/**租期*/
@property (nonatomic , copy) NSString *rentPeriod;
/**租期*/
@property (nonatomic , assign) int periods;
/**优惠劵减免费用*/
@property (nonatomic , assign) double couponPrice;
/**账单ID*/
@property (nonatomic , copy) NSString *billId;
/**增值服务列表(serivceName,serivcePrice)*/
@property (nonatomic , strong) NSArray *addedList;
/**归还超时天数*/
@property (nonatomic , assign) int returnOverDays;
/**是否显示支付违约金按钮*/
@property (nonatomic , assign) BOOL isPenalty;
/**是否可续租*/
@property (nonatomic , assign) BOOL isRelet;
/**0正常 1取消中 2取消驳回*/
@property (nonatomic , assign) int isCanceling;
/**活动优惠是否可叠加优惠券*/
@property (nonatomic , assign) BOOL isSuperimposed;
/**活动优惠价格*/
@property (nonatomic , assign) double activityAmount;
/**是否有活动优惠*/
@property (nonatomic , assign) BOOL isHaveActivity;
/**是否上传过快递单号*/
@property (nonatomic , assign) BOOL isReturnBack;
/**是否买断*/
@property (nonatomic , assign) BOOL isBuyOutBO;
/**买断支付的违约金*/
@property (nonatomic , assign) double penaltyAmountBO;
/**活动优惠是否可叠加优惠券*/
@property (nonatomic , assign) BOOL isSuperimposedBO;
/**活动优惠价格*/
@property (nonatomic , assign) double activityAmountBO;
/**是否有活动优惠*/
@property (nonatomic , assign) BOOL isHaveActivityBO;
/**商品价值*/
@property (nonatomic , assign) double goodsValueBO;
/**溢价系数*/
@property (nonatomic , copy) NSString *premiumCoefficientBO;
/**已支付租金*/
@property (nonatomic , assign) double hasPayBO;
/**已支付押金*/
@property (nonatomic , assign) double hasDepositBO;
/**活动优惠*/
@property (nonatomic , assign) double activityDiscountBO;
/**优惠券*/
@property (nonatomic , assign) double couponBO;
/**应付总额*/
@property (nonatomic , assign) double shouldPayAmountBO;
/**抵扣后已支付*/
@property (nonatomic , assign) double hasPayAmountBO;
/**到期时间*/
@property (nonatomic , copy) NSString *returnDate;
/**起租时间*/
@property (nonatomic , copy) NSString *leaseStartTime;


/**本地计算：总价格*/
@property (nonatomic , assign) double localTotalPrice;

@end
