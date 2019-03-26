//
//  InsertRentOrder.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/14.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**创建订单参数*/
@interface _p_InsertRentOrder : ZYBaseParam

/**价格id*/
@property (nonatomic , copy) NSString *priceId;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**增值服务IDs，中间用,隔开*/
@property (nonatomic , copy) NSString *serviceIds;
/**收货地址id*/
@property (nonatomic , copy) NSString *addressId;
/**优惠券id*/
@property (nonatomic , copy) NSString *couponId;
/**经度*/
@property (nonatomic , copy) NSString *longitude;
/**纬度*/
@property (nonatomic , copy) NSString *latitude;
/**买家留言*/
@property (nonatomic , copy) NSString *buyerMessage;
/**发货类型 1：邮寄 2：自提*/
@property (nonatomic , copy) NSString *expressType;
/**门店地址*/
@property (nonatomic , copy) NSString *storeAddress;
/**门店名称*/
@property (nonatomic , copy) NSString *storeName;
/**门店电话*/
@property (nonatomic , copy) NSString *storeMobile;
/**支付宝资金授权号*/
@property (nonatomic , copy) NSString *fundAuthNo;

@end




/**创建订单返回*/
@interface _m_InsertRentOrder : ZYBaseModel

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**账单编号*/
@property (nonatomic , copy) NSString *billId;

@end
