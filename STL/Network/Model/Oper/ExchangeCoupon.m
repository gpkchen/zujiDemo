//
//  ExchangeCoupon.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ExchangeCoupon.h"

@implementation _p_ExchangeCoupon

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/redeemCode/exchange";
    }
    return self;
}

@end
