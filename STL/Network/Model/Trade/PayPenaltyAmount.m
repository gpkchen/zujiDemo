//
//  PayPenaltyAmount.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "PayPenaltyAmount.h"

@implementation _p_PayPenaltyAmount

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/payPenaltyAmount";
    }
    return self;
}

@end
