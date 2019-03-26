//
//  GetOrderList.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetOrderList.h"

@implementation _p_GetOrderList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getOrderList";
        self.size = ZYRequestDefaultPageSize;
    }
    return self;
}

@end

@implementation _m_GetOrderList

@end
