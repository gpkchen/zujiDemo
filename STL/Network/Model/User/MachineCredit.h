//
//  MachineCredit.h
//  Apollo
//
//  Created by shaxia on 2018/5/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**用户发起机审授信查询参数*/
@interface _p_MachineCredit : ZYBaseParam

/**设备指纹*/
@property (nonatomic , strong) NSString *deviceFinger;
/**经度*/
@property (nonatomic , strong) NSString *longitude;
/**纬度*/
@property (nonatomic , strong) NSString *latitude;
/**是否保存信息标志（在获取免押额度时传1，其他不传）*/
@property (nonatomic , strong) NSString *flag;

@end

/**用户发起机审授信查询返回*/
@interface _m_MachineCredit : ZYBaseModel

@end
