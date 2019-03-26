//
//  LimitRecord.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/31.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "LimitRecord.h"

@implementation _p_LimitRecord

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/user/limitChange/record";
        _size = ZYRequestDefaultPageSize;
    }
    return self;
}

@end





@implementation _m_LimitRecord

@end
