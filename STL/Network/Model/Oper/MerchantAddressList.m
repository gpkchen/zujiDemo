//
//  MerchantAddressList.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/14.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "MerchantAddressList.h"

@implementation _p_MerchantAddressList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"app/oper/merchant/addressList";
        self.size = ZYRequestDefaultPageSize;
    }
    return self;
}

@end



@implementation _m_MerchantAddressList


@end
