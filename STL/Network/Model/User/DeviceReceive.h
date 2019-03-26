//
//  DeviceReceive.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**上传设备信息参数*/
@interface _p_DeviceReceive : ZYBaseParam

/**设备唯一标识*/
@property (nonatomic , copy) NSString *identifier;
/**设备IMEI*/
@property (nonatomic , copy) NSString *imei;
/**设备IDFA*/
@property (nonatomic , copy) NSString *idfa;
/**设备类型 1ios 2android*/
@property (nonatomic , copy) NSString *deviceType;
/**设备品牌*/
@property (nonatomic , copy) NSString *brand;
/**设备型号*/
@property (nonatomic , copy) NSString *deviceModel;
/**系统版本*/
@property (nonatomic , copy) NSString *osVersion;

@end
