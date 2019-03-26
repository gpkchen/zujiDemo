//
//  GetCreateOrderInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**下单成功信息查询参数*/
@interface _p_GetCreateOrderInfo : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;

@end




/**下单成功信息查询返回*/
@interface _m_GetCreateOrderInfo : ZYBaseModel

/**租金*/
@property (nonatomic , copy) NSString *rentPrice;
/**租期*/
@property (nonatomic , copy) NSString *rentPeriod;
/**押金*/
@property (nonatomic , copy) NSString *deposit;
/**租期类型*/
@property (nonatomic , assign) ZYRentType rentType;
/**邮寄方式*/
@property (nonatomic , assign) ZYExpressType expressType;

@end
