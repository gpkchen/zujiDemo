//
//  GetPreOrderInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/18.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**下单确认页信息查询参数*/
@interface _p_GetPreOrderInfo : ZYBaseParam

/**价格id*/
@property (nonatomic , copy) NSString *priceId;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**增值服务IDs，中间用,隔开*/
@property (nonatomic , copy) NSString *serviceIds;
/**支付宝资金授权号*/
@property (nonatomic , copy) NSString *fundAuthNo;

@end




/**下单确认页信息查询返回*/
@interface _m_GetPreOrderInfo : ZYBaseModel

/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**宝贝图片*/
@property (nonatomic , copy) NSString *imageUrl;
/**规格*/
@property (nonatomic , copy) NSString *goodsSkuNames;
/**租金，带￥和单位*/
@property (nonatomic , copy) NSString *rentPrice;
/**商品押金*/
@property (nonatomic , assign) double deposit;
/**减免押金*/
@property (nonatomic , assign) double reductionDeposit;
/**需支付押金*/
@property (nonatomic , assign) double payDeposit;
/**租期类型 1：长租 2：短租*/
@property (nonatomic , assign) ZYRentType rentType;
/**租金*/
@property (nonatomic , assign) double monthPay;
/**租期 带月或日*/
@property (nonatomic , copy) NSString *rentPeriod;
/**租期（数字）*/
@property (nonatomic , assign) int periods;
/**增值服务数组（name，price）*/
@property (nonatomic , strong) NSArray *addedPriceList;
/**活动优惠价格*/
@property (nonatomic , assign) double activityDiscountAmount;
/**活动优惠是否可叠加优惠券*/
@property (nonatomic , assign) BOOL isSuperimposed;
/**是否有活动优惠*/
@property (nonatomic , assign) BOOL isHaveActivity;
/**实际支付押金*/
@property (nonatomic , assign) double needPayDeposit;
/**商品id*/
@property (nonatomic , copy) NSString *itemId;

@end

NS_ASSUME_NONNULL_END
