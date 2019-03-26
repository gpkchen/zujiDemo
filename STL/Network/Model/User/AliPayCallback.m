//
//  AliPayCallback.m
//  Apollo
//
//  Created by shaxia on 2018/5/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AliPayCallback.h"

@implementation _p_AliPayCallback

- (instancetype)init{
    if(self = [super init]){
        self.url = @"app/user/alipay/callback";
    }
    return self;
}

@end

@implementation _m_AliPayCallback
@end
