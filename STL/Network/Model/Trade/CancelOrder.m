//
//  CancelOrder.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "CancelOrder.h"

@implementation _p_CancelOrder

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/cancelOrder";
    }
    return self;
}

@end
