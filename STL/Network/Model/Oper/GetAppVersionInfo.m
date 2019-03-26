//
//  GetAppVersionInfo.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetAppVersionInfo.h"

@implementation _p_GetAppVersionInfo

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/appVersion/getAppVersionInfo";
        self.needApiToekn = NO;
    }
    return self;
}

@end






@implementation _m_GetAppVersionInfo

@end
