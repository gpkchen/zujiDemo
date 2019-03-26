//
//  OrderGetAddress.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/14.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**确认订单信息参数*/
@interface _p_OrderGetAddress : ZYBaseParam

/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**经度*/
@property (nonatomic , copy) NSString *longitude;
/**纬度*/
@property (nonatomic , copy) NSString *latitude;

@end




/**确认订单信息返回*/
@interface _m_OrderGetAddress : ZYBaseModel

/**收货地址id*/
@property (nonatomic , copy) NSString *reciveAddressId;
/**收货人姓名*/
@property (nonatomic , copy) NSString *contact;
/**收货人电话*/
@property (nonatomic , copy) NSString *mobile;
/**收货地址*/
@property (nonatomic , copy) NSString *commonAddress;
/**门店id*/
@property (nonatomic , copy) NSString *merchantAddressId;
/**门店名称*/
@property (nonatomic , copy) NSString *addressName;
/**门店电话*/
@property (nonatomic , copy) NSString *telephone;
/**门店地址*/
@property (nonatomic , copy) NSString *completeAddress;
/**门店距离*/
@property (nonatomic , copy) NSString *distance;

@end
