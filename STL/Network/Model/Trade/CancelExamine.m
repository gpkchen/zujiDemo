//
//  CancelExamine.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "CancelExamine.h"

@implementation _p_CancelExamine

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/cancelExamine";
    }
    return self;
}

@end
