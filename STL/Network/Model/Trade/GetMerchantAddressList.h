//
//  GetMerchantAddressList.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**商户地址查询参数*/
@interface _p_GetMerchantAddressList : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**1-上门归还 2-邮寄归还 3-上门自提*/
@property (nonatomic , copy) NSString *addressUseScene;
/**经度*/
@property (nonatomic , copy) NSString *longitude;
/**纬度*/
@property (nonatomic , copy) NSString *latitude;

@property (nonatomic , copy) NSString *page;
@property (nonatomic , copy) NSString *size;

@end



/**商户地址查询返回*/
@interface _m_GetMerchantAddressList : ZYBaseModel

/**联系人*/
@property (nonatomic , copy) NSString *contact;
/**电话*/
@property (nonatomic , copy) NSString *telephone;
/**详细地址*/
@property (nonatomic , copy) NSString *completeAddress;
/**地址名称*/
@property (nonatomic , copy) NSString *addressName;
/**地址id*/
@property (nonatomic , copy) NSString *merchantAddressId;
/**距离*/
@property (nonatomic , copy) NSString *distance;

/**本地：记录cell高度*/
@property (nonatomic , assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
