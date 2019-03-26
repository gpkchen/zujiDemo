//
//  DeviceReceive.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "DeviceReceive.h"

@implementation _p_DeviceReceive

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/user/device/receive";
        self.identifier = [ZYDeviceUtils utils].uuidForDevice;
        self.idfa = [ZYDeviceUtils utils].idfa;
        self.deviceType = @"1";
        self.osVersion = [ZYDeviceUtils utils].systemVersion;
        self.brand = @"Apple";
        self.deviceModel = [ZYDeviceUtils utils].deviceModel;
    }
    return self;
}

@end
