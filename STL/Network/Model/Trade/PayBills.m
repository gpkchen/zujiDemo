//
//  PayBills.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "PayBills.h"

@implementation _p_PayBills

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/payBills";
        self.apiVersion = @"2";
    }
    return self;
}

@end
