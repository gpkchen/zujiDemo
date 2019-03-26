//
//  Login.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "Login.h"
#import "ZYLocationUtils.h"

@implementation _p_Login

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/user/active/login";
        self.latitude = [ZYLocationUtils utils].userLocation.latitude;
        self.longitude = [ZYLocationUtils utils].userLocation.longitude;
        self.needApiToekn = NO;
    }
    return self;
}

@end





@implementation _m_Login

@end
