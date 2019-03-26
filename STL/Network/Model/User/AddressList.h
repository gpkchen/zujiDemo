//
//  AddressList.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"

/**收货地址列表查询参数*/
@interface _p_AddressList : ZYBaseParam

@end



/**收货地址列表查询返回*/
@interface _m_AddressList : ZYBaseModel

/**地址id*/
@property (nonatomic , copy) NSString *addressId;
/**联系人*/
@property (nonatomic , copy) NSString *contact;
/**手机号*/
@property (nonatomic , copy) NSString *mobile;
/**省份*/
@property (nonatomic , copy) NSString *provinceName;
/**城市*/
@property (nonatomic , copy) NSString *cityName;
/**区域*/
@property (nonatomic , copy) NSString *districtName;
/**详细地址*/
@property (nonatomic , copy) NSString *address;
/**是否默认地址*/
@property (nonatomic , assign) BOOL isDefault;

@end

