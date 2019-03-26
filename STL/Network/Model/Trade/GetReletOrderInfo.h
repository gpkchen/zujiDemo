//
//  GetReletOrderInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**续租详情请求参数*/
@interface _p_GetReletOrderInfo : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;

@end





/**续租详情请求返回*/
@interface _m_GetReletOrderInfo : ZYBaseModel

/**宝贝图片*/
@property (nonatomic , copy) NSString *imageUrl;
/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**规格*/
@property (nonatomic , copy) NSString *goodsSkuNames;
/**租金（带单位）*/
@property (nonatomic , copy) NSString *rentPrice;
/**租金*/
@property (nonatomic , assign) double monthPay;
/**违约金*/
@property (nonatomic , assign) double penaltyAmount;
/**租期类型（长期短期）*/
@property (nonatomic , assign) ZYRentType showRentType;
/**商品id*/
@property (nonatomic , copy) NSString *itemId;
/**商品类目id*/
@property (nonatomic , copy) NSString *categoryId;
/**默认期数*/
@property (nonatomic , assign) int defaultPeriod;

@end
