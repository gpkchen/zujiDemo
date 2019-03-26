//
//  AppModuleList.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AppModuleList.h"

@implementation _p_AppModuleList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/module/moduleList";
        self.needApiToekn = NO;
    }
    return self;
}

@end





@implementation _m_AppModuleList

@end
