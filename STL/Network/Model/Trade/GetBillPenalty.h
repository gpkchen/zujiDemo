//
//  GetBillPenalty.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**账单违约金查询参数*/
@interface _p_GetBillPenalty : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**账单id*/
@property (nonatomic , copy) NSString *billIds;
/**1：单笔账单 2：所有剩余账单*/
@property (nonatomic , copy) NSString *payBillType;

@end



@interface _m_GetBillPenalty : ZYBaseModel

/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**规格*/
@property (nonatomic , copy) NSString *goodsSkuNames;
/**宝贝图片*/
@property (nonatomic , copy) NSString *imageUrl;
/**租金（带单位）*/
@property (nonatomic , copy) NSString *rentPrice;
/**商品价值*/
@property (nonatomic , assign) double marketPrice;
/**逾期天数*/
@property (nonatomic , assign) int overdueDays;
/**每天违约金额计算方式*/
@property (nonatomic , copy) NSString *penaltyAmountWay;
/**每天违约金额*/
@property (nonatomic , assign) double penaltyAmount;
/**应付违约金额计算方式*/
@property (nonatomic , copy) NSString *payPenaltyAmountWay;
/**应付违约金额*/
@property (nonatomic , assign) double payPenaltyAmount;
/**减免金额*/
@property (nonatomic , assign) double reductionAmount;

@end
