//
//  GetCouponAmount.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetCouponAmount.h"

@implementation _p_GetCouponAmount

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getCouponAmount";
        self.apiVersion = @"2";
    }
    return self;
}

@end




@implementation _m_GetCouponAmount

@end
