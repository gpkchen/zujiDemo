//
//  GetMyHomeInfo.m
//  Apollo
//
//  Created by shaxia on 2018/5/14.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetMyHomeInfo.h"

@implementation _p_GetMyHomeInfo

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getMyHomeInfo";
    }
    return self;
}

@end

@implementation _m_GetMyHomeInfo_maps

@end

@implementation _m_GetMyHomeInfo

+ (NSDictionary *) mj_objectClassInArray{
    return @{@"maps":@"_m_GetMyHomeInfo_maps"};
}

@end
