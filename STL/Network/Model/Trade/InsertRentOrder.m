//
//  InsertRentOrder.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/14.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "InsertRentOrder.h"

@implementation _p_InsertRentOrder

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/insertRentOrder";
        self.apiVersion = @"2";
    }
    return self;
}

@end



@implementation _m_InsertRentOrder

@end
