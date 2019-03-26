//
//  GetPayBillInfo.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetPayBillInfo.h"

@implementation _p_GetPayBillInfo

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getPayBillInfo";
    }
    return self;
}

@end




@implementation _m_GetPayBillInfo

@end
