//
//  PreOrderRiskVerify.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/26.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**下单前风控查询参数*/
@interface _p_PreOrderRiskVerify : ZYBaseParam

/**商品id*/
@property (nonatomic , copy) NSString *itemId;
/**价格id*/
@property (nonatomic , copy) NSString *priceId;
/**增值服务id*/
@property (nonatomic , copy) NSString *serviceIds;

@end



/**下单前风控查询返回*/
@interface _m_PreOrderRiskVerify : ZYBaseModel

/**用户历史订单状态 0：正常 1：用户有订单异常 2：用户有账单逾期 3：用户有到期未归还订单*/
@property (nonatomic , assign) int abnormalOrderType;
/**非正常订单id*/
@property (nonatomic , copy) NSString *abnormalOrderId;
/**用户可用免押额度*/
@property (nonatomic , assign) double surplusLimit;
/**商品押金*/
@property (nonatomic , assign) double deposit;
/**是否触发贷中风控*/
@property (nonatomic , assign) BOOL isLoanControl;
/**是否大于最大租赁件数*/
@property (nonatomic , assign) BOOL isOverMaxNum;
/**支付宝授权调起参数*/
@property (nonatomic , copy) NSString *alipayInfo;
/**支付宝资金授权单号*/
@property (nonatomic , copy) NSString *fundAuthNo;
/**是否授过信*/
@property (nonatomic , assign) BOOL isCredited;

@end

NS_ASSUME_NONNULL_END
