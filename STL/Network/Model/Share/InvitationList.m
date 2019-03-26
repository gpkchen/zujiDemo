//
//  InvitationList.m
//  Apollo
//
//  Created by shaxia on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "InvitationList.h"

@implementation _p_InvitationList
- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/user/invitation/list";
    }
    return self;
}
@end

@implementation _m_InvitationList

+ (NSDictionary *) mj_objectClassInArray{
    return @{@"list":@"_m_InvitationList_list"};
}

@end

@implementation _m_InvitationList_list

@end
