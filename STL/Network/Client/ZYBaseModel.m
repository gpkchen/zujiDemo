//
//  ZYBaseModel.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseModel.h"

@implementation ZYBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [[self class] mj_objectWithKeyValues:dic];
    return self;
}

@end
