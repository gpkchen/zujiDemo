//
//  GetVerificationCode.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetVerificationCode.h"

@implementation _p_GetVerificationCode

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/system/GetVerificationCode";
        self.needApiToekn = NO;
    }
    return self;
}

- (NSDictionary *)getDicParam{
    NSString *deviceID = [ZYDeviceUtils utils].uuidForDevice;
    NSString *time = self.timestamp;
    NSString *pSign = [[NSString stringWithFormat:@"%@%@",_mobile,_scene] md5];
    NSString *fSign = [[NSString stringWithFormat:@"%@%@",deviceID,time] md5];
    NSString *bSign = [NSString stringWithFormat:@"%@%@",pSign,fSign];
    _sign = [bSign substringWithRange:NSMakeRange(15, 32)];
    return [super getDicParam];
}

@end

