//
//  AddressDetail.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**获取地址详情参数*/
@interface _p_AddressDetail : ZYBaseParam

/**地址id*/
@property (nonatomic , copy) NSString *addressId;

@end



/**获取地址详情返回*/
@interface _m_AddressDetail : ZYBaseModel

/**地址id*/
@property (nonatomic , copy) NSString *addressId;
/**收货人*/
@property (nonatomic , copy) NSString *contact;
/**手机号*/
@property (nonatomic , copy) NSString *mobile;
/**省code*/
@property (nonatomic , copy) NSString *provinceCode    ;
/**市code*/
@property (nonatomic , copy) NSString *cityCode;
/**区code*/
@property (nonatomic , copy) NSString *districtCode;
/**省名称*/
@property (nonatomic , copy) NSString *provinceName;
/**市名称*/
@property (nonatomic , copy) NSString *cityName;
/**区名称*/
@property (nonatomic , copy) NSString *districtName;
/**详细地址*/
@property (nonatomic , copy) NSString *address;
/**是否默认地址*/
@property (nonatomic , assign) BOOL isDefault;

@end
