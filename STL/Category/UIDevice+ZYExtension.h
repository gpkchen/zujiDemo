//
//  UIDevice+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ZYExtension)

/**版本号*/
@property (nonatomic, readonly) float iOSVer;
/**设备型号 如 "iPhone6,1" "iPad4,6"*/
@property (nonatomic, readonly) NSString *machineModel;
/**设备型号 如 "iPhone 5s" "iPad mini 2"*/
@property (nonatomic, readonly) NSString *machineModelName;
/**系统启动时间*/
@property (nonatomic, readonly) NSDate *systemStartUptime;
/**WIFI环境的IP地址，出错返回 nil*/
@property (nonatomic, readonly) NSString *ipAddressWIFI;
/**CPU 核心数*/
@property (nonatomic, readonly) NSUInteger cpuCount;
/**磁盘总量 单位 byte, 出错返回 -1*/
@property (nonatomic, readonly) int64_t diskSpace;
/**可用磁盘容量 单位 byte, 出错返回 -1*/
@property (nonatomic, readonly) int64_t diskSpaceFree;
/**已用磁盘容量 单位 byte, 出错返回 -1*/
@property (nonatomic, readonly) int64_t diskSpaceUsed;
/**物理内存总量 单位 byte, 出错返回 -1*/
@property (nonatomic, readonly) int64_t memoryTotal;
/**Used (active + inactive + wired) memory in byte. (-1 when error occurs)*/
@property (nonatomic, readonly) int64_t memoryUsed;
/**Free memory in byte. (-1 when error occurs)*/
@property (nonatomic, readonly) int64_t memoryFree;
/**Acvite memory in byte. (-1 when error occurs)*/
@property (nonatomic, readonly) int64_t memoryActive;
/**Inactive memory in byte. (-1 when error occurs)*/
@property (nonatomic, readonly) int64_t memoryInactive;
/**Wired memory in byte. (-1 when error occurs)*/
@property (nonatomic, readonly) int64_t memoryWired;
/**Purgable memory in byte. (-1 when error occurs)*/
@property (nonatomic, readonly) int64_t memoryPurgable;

@end
