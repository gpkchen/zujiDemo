//
//  GetPenaltyOrderInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**违约金详情查询参数*/
@interface _p_GetPenaltyOrderInfo : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;

@end



/**违约金详情查询返回*/
@interface _m_GetPenaltyOrderInfo : ZYBaseModel

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
/**检测违约金金额*/
@property (nonatomic , assign) double checkPenaltyAmount;
/**检测违约金金额计算方式*/
@property (nonatomic , copy) NSString *checkPenaltyAmountWay;
/**减免违约金额*/
@property (nonatomic , assign) double reductionAmount;
/**减免检测违约金金额*/
@property (nonatomic , assign) double reductionCheckAmount;

@end
