//
//  ReceiveCoupon.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/29.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ReceiveCoupon.h"

@implementation _p_ReceiveCoupon

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/couponGrant/receive";
    }
    return self;
}

@end
