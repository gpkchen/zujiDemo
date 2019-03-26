//
//  GetPayBillInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**账单还款详情查询参数*/
@interface _p_GetPayBillInfo : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**订单id*/
@property (nonatomic , copy) NSString *billIds;
/**1：单笔账单 2：所有剩余账单*/
@property (nonatomic , copy) NSString *payBillType;

@end





/**账单还款详情查询返回*/
@interface _m_GetPayBillInfo : ZYBaseModel

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
/**品类ID*/
@property (nonatomic , copy) NSString *categoryId;
/**账单状态*/
@property (nonatomic , assign) ZYBillState status;
/**租金*/
@property (nonatomic , copy) NSString *rentPrice;
/**还款时间*/
@property (nonatomic , copy) NSString *repaymentDate;
/**逾期天数*/
@property (nonatomic , assign) int overdueDays;
/**逾期金额*/
@property (nonatomic , assign) double overdueAmount;
/**支付租金金额*/
@property (nonatomic , assign) double payAmount;
/**支付总金额*/
@property (nonatomic , assign) double payAllAmount;
/**支付账单ID集合*/
@property (nonatomic , copy) NSString *billIds;
/**支付期数集合*/
@property (nonatomic , copy) NSString *rentPeriods;

@end
