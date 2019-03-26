//
//  GetBillPenalty.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetBillPenalty.h"

@implementation _p_GetBillPenalty

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getBillPenalty";
    }
    return self;
}

@end



@implementation _m_GetBillPenalty

@end
