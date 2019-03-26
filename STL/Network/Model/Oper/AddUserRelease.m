//
//  AddUserRelease.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AddUserRelease.h"

@implementation _p_AddUserRelease

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/userRelease/addUserRelease";
    }
    return self;
}

@end
