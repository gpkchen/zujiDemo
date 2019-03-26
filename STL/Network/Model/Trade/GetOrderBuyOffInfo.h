//
//  GetOrderBuyOffInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**买单信息查询参数*/
@interface _p_GetOrderBuyOffInfo : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;

@end





/**买单信息查询参数*/
@interface _m_GetOrderBuyOffInfo : ZYBaseModel

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**规格*/
@property (nonatomic , copy) NSString *goodsSkuNames;
/**租金*/
@property (nonatomic , copy) NSString *rentPrice;
/**宝贝图片*/
@property (nonatomic , copy) NSString *imageUrl;
/**宝贝市场价格*/
@property (nonatomic , assign) double marketPrice;
/**溢价系数 带%号*/
@property (nonatomic , copy) NSString *premium;
/**支付押金*/
@property (nonatomic , assign) double payDeposit;
/**支付账单金额*/
@property (nonatomic , assign) double payBIllAmount;
/**计算价格方式*/
@property (nonatomic , copy) NSString *method;
/**应付总额 商品价值x溢价系数*/
@property (nonatomic , assign) double payAllAmount;
/**抵扣后需要支付*/
@property (nonatomic , assign) double payAmount;
/**退还金额*/
@property (nonatomic , assign) double backAmount;
/**类型 1:支付 2：退还*/
@property (nonatomic , assign) ZYBuyOffPayType type;
/**违约金*/
@property (nonatomic , assign) double penaltyAmount;
/**活动优惠价格*/
@property (nonatomic , assign) double activityDiscountAmount;
/**活动优惠是否可叠加优惠券*/
@property (nonatomic , assign) BOOL isSuperimposed;
/**是否有活动优惠*/
@property (nonatomic , assign) BOOL isHaveActivity;

@end
