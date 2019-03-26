//
//  GetGoodsSearchKeyList.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetGoodsSearchKeyList.h"

@implementation _p_GetGoodsSearchKeyList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/goods/sku/getGoodsSearchKeyList";
        self.needApiToekn = NO;
    }
    return self;
}

@end




@implementation _m_GetGoodsSearchKeyList

@end
