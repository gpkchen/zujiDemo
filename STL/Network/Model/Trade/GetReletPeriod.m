//
//  GetReletPeriod.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetReletPeriod.h"

@implementation _p_GetReletPeriod

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getReletPeriod";
    }
    return self;
}

@end



@implementation _m_GetReletPeriod
@end
