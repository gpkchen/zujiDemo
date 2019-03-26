//
//  AppListItem.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AppListItem.h"

@implementation _p_AppListItem

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/configureItem/appListItem";
        self.needApiToekn = NO;
        self.size = ZYRequestDefaultPageSize;
    }
    return self;
}

@end






@implementation _m_AppListItem

@end
