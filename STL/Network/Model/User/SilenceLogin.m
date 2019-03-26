//
//  SilenceLogin.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "SilenceLogin.h"

@implementation _p_SilenceLogin

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/user/silent/login";
        self.needApiToekn = NO;
    }
    return self;
}

@end



@implementation _m_SilenceLogin

@end
