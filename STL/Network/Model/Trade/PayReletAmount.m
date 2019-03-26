//
//  PayReletAmount.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "PayReletAmount.h"

@implementation _p_PayReletAmount

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/payReletAmount";
        self.apiVersion = @"2";
    }
    return self;
}

@end
