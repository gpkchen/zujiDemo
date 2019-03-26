//
//  ConfirmRecive.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ConfirmRecive.h"

@implementation _p_ConfirmRecive

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/confirmRecive";
    }
    return self;
}

@end
