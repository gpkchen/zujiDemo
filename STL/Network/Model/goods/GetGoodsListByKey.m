//
//  GetGoodsListByKey.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetGoodsListByKey.h"

@implementation _p_GetGoodsListByKey

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/goods/sku/getGoodsListByKey";
        self.needApiToekn = NO;
        _size = ZYRequestDefaultPageSize;
    }
    return self;
}

@end



@implementation _m_GetGoodsListByKey

@end
