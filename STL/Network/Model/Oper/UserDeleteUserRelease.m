//
//  UserDeleteUserRelease.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/30.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UserDeleteUserRelease.h"

@implementation _p_UserDeleteUserRelease

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/userRelease/userDeleteUserRelease";
    }
    return self;
}

@end
