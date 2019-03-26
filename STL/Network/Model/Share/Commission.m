//
//  Commission.m
//  Apollo
//
//  Created by shaxia on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "Commission.h"

@implementation _p_Commission
- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/user/make/commission";
        self.needApiToekn = NO;
    }
    return self;
}
@end



@implementation _m_Commission

+ (NSDictionary *) mj_objectClassInArray{
    return @{@"rollerList":@"_m_Commission_rollerList"};
}
@end

@implementation _m_Commission_rollerList

@end
