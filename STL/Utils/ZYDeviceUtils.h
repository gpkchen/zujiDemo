//
//  ZYDeviceUtils.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYDeviceUtils : NSObject

/**获取设备标识码*/
@property (nonatomic , copy , readonly) NSString * uuidForDevice;
/**idfa*/
@property (nonatomic , copy , readonly) NSString *idfa;
/**系统版本*/
@property (nonatomic , copy , readonly) NSString *systemVersion;
/**设备型号*/
@property (nonatomic , copy , readonly) NSString *deviceModel;

/**单例*/
+ (instancetype) utils;

@end
