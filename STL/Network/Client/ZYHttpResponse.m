//
//  ZYHttpResponse.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYHttpResponse.h"

@implementation ZYHttpResponse

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if(dic){
        self = [[self class] mj_objectWithKeyValues:dic];
        _success = _code == ZYHttpResponseCodeSuccess;
        return self;
    }
    return nil;
}

@end
