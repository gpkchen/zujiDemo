//
//  GetPenaltyOrderInfo.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetPenaltyOrderInfo.h"

@implementation _p_GetPenaltyOrderInfo

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getPenaltyOrderInfo";
    }
    return self;
}

@end




@implementation _m_GetPenaltyOrderInfo

@end
