//
//  GetMerchantAddressList.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "GetMerchantAddressList.h"

@implementation _p_GetMerchantAddressList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getMerchantAddressList";
        self.size = ZYRequestDefaultPageSize;
    }
    return self;
}

@end






@implementation _m_GetMerchantAddressList

@end
