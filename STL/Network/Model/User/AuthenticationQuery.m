//
//  AuthenticationQuery.m
//  Apollo
//
//  Created by shaxia on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AuthenticationQuery.h"

@implementation _p_AuthenticationQuery
- (instancetype)init{
    if(self = [super init]){
        self.url = @"app/user/authentication/query";
    }
    return self;
}
@end

@implementation _m_AuthenticationQuery
@end
