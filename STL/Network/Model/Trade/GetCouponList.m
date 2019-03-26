//
//  GetCouponList.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetCouponList.h"

@implementation _p_GetCouponList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getAvailableCouponList";
        self.size = ZYRequestDefaultPageSize;
    }
    return self;
}

@end
