//
//  AuditState.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AuditState.h"

@implementation _p_AuditState

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/user/audit/state";
        self.apiVersion = @"2";
    }
    return self;
}

@end




@implementation _m_AuditState

@end
