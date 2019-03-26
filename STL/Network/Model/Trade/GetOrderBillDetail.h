//
//  GetOrderBillDetail.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**账单详情查询参数*/
@interface _p_GetOrderBillDetail : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;

@end






/**账单详情查询返回*/
@interface _m_GetOrderBillDetail : ZYBaseModel

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**宝贝图片*/
@property (nonatomic , copy) NSString *imageUrl;
/**规格*/
@property (nonatomic , copy) NSString *goodsSkuNames;
/**租金*/
@property (nonatomic , copy) NSString *rentPrice;
/**应还租金*/
@property (nonatomic , assign) double allRentPrice;
/**已还租金*/
@property (nonatomic , assign) double haveRentPrice;
/**待还租金*/
@property (nonatomic , assign) double needRentPrice;
/**所有账单是否已还清*/
@property (nonatomic , assign) BOOL isPayAllBills;
/**租期类型*/
@property (nonatomic , assign) ZYRentType rentType;
/**账单列表*/
@property (nonatomic , strong) NSArray *billList;

@end




@interface _m_GetOrderBillDetail_Bill : ZYBaseModel

/**租期类型*/
@property (nonatomic , assign) ZYRentType rentType;
/**账单ID*/
@property (nonatomic , copy) NSString *billId;
/**租金*/
@property (nonatomic , assign) double rentPrice;
/**当前期数*/
@property (nonatomic , assign) int nowRentPeriod;
/**总租期*/
@property (nonatomic , assign) int allRentPeriod;
/**还款日*/
@property (nonatomic , copy) NSString *repaymentDate;
/**账单状态*/
@property (nonatomic , assign) ZYBillState billStatus;
/**逾期天数*/
@property (nonatomic , assign) int overdueDays;
/**逾期金额*/
@property (nonatomic , assign) double overdueFee;
/**是否允许支付*/
@property (nonatomic , assign) BOOL isAllowPay;

@end
