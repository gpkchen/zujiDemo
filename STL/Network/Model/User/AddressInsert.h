//
//  AddressInsert.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**新建/修改地址参数*/
@interface _p_AddressInsert : ZYBaseParam

/**地址id*/
@property (nonatomic , copy) NSString *addressId;
/**联系人*/
@property (nonatomic , copy) NSString *contact;
/**手机号*/
@property (nonatomic , copy) NSString *mobile;
/**省份id*/
@property (nonatomic , copy) NSString *provinceCode;
/**城市id*/
@property (nonatomic , copy) NSString *cityCode;
/**地区id*/
@property (nonatomic , copy) NSString *districtCode;
/**详细地址*/
@property (nonatomic , copy) NSString *address;
/**1：是默认地址，0：不是*/
@property (nonatomic , copy) NSString *isDefault;

@end
