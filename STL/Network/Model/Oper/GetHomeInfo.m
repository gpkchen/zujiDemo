//
//  GetHomeInfo.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetHomeInfo.h"

@implementation _p_GetHomeInfo

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/getHomeInfo";
        self.needApiToekn = NO;
    }
    return self;
}

@end


@implementation _m_GetHomeInfo

@end
